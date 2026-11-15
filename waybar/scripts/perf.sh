#!/usr/bin/env bash
# CPU performance mode cycler.
#
# Three states, because platform_profile on its own is too coarse -- measured on
# this machine, the only things power-profiles-daemon changes are EPP
# (balance_performance -> performance) and Dell's EC fan curve. PL1, no_turbo and
# max_perf_pct are identical across all three profiles.
#
#   balanced  PPD balanced,    max_perf_pct 100   default, coolest
#   blend     PPD performance, max_perf_pct 85    fans up, clocks capped
#   turbo     PPD performance, max_perf_pct 100   nothing held back
#
# "blend" is the useful one on this chassis. It throttled for 149s of a 49min
# uptime while sitting at 92C with the fans at ~55%, so the top slice of boost is
# not actually reachable for any length of time. Raising the fan curve while
# capping the ceiling trades unreachable peak clock for higher sustained clock.
set -uo pipefail

STATE="$HOME/.config/waybar/.perf"
PCT_PATH="/sys/devices/system/cpu/intel_pstate/max_perf_pct"
BLEND_PCT=85

[[ -f $STATE ]] || echo balanced >"$STATE"
mode=$(<"$STATE")
case $mode in balanced | blend | turbo) ;; *) mode=balanced ;; esac

# Writing max_perf_pct needs root. With the sudoers drop-in installed this is
# silent; without it the profile still switches and only the cap is skipped, so
# the toggle degrades to a plain balanced/performance switch rather than failing.
set_pct() {
  if [[ -w $PCT_PATH ]]; then
    printf '%s' "$1" >"$PCT_PATH" 2>/dev/null && return
  fi
  printf '%s' "$1" | sudo -n tee "$PCT_PATH" >/dev/null 2>&1 || true
}

apply() {
  case "$1" in
    balanced) powerprofilesctl set balanced >/dev/null 2>&1; set_pct 100 ;;
    blend)    powerprofilesctl set performance >/dev/null 2>&1; set_pct "$BLEND_PCT" ;;
    turbo)    powerprofilesctl set performance >/dev/null 2>&1; set_pct 100 ;;
  esac
}

cycle() {
  local next
  case "$mode" in
    balanced) next=blend ;;
    blend)    next=turbo ;;
    *)        next=balanced ;;
  esac

  echo "$next" >"$STATE"
  apply "$next"
}

case "${1:-}" in
  cycle)   cycle ;;
  restore) apply "$mode" ;;
  *)       echo "usage: perf.sh [cycle|restore]" >&2; exit 1 ;;
esac
