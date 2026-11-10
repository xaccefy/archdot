#!/bin/sh
# tmux-timer — countdown/count-up timer in the tmux status bar.
#
# The status bar runs `tmux-timer.sh line` every second (status-interval 1)
# and prints the output verbatim, including any #[...] styles embedded in it
# (verified on tmux 3.8: styles inside #() output are parsed).
#
#   tmux-timer.sh toggle     count-up: start if idle, stop and clear if running
#   tmux-timer.sh set N      countdown of N minutes; empty/0/junk clears the timer
#   tmux-timer.sh clear      stop and clear any timer
#   tmux-timer.sh line       print the status segment (called by tmux)
#
# State: ${XDG_RUNTIME_DIR:-/tmp}/tmux-timer-$(id -u), one line:
#   "up <start-epoch>"  or  "down <start-epoch> <duration-seconds>"

state="${TMUX_TIMER_STATE:-${XDG_RUNTIME_DIR:-/tmp}/tmux-timer-$(id -u)}"
now() { date +%s; }

# mm:ss, or h:mm:ss once it passes an hour
fmt_time() {
  s=$1
  [ "$s" -lt 0 ] && s=0
  h=$((s / 3600)); m=$((s / 60 % 60)); sec=$((s % 60))
  if [ "$h" -gt 0 ]; then
    printf '%d:%02d:%02d' "$h" "$m" "$sec"
  else
    printf '%02d:%02d' "$m" "$sec"
  fi
}

case "${1:-}" in
toggle)
  if [ -f "$state" ]; then
    rm -f "$state"
    [ -n "$TMUX" ] && tmux display-message "timer cleared" 2>/dev/null || true
  else
    printf 'up %s\n' "$(now)" > "$state"
    [ -n "$TMUX" ] && tmux display-message "count-up started" 2>/dev/null || true
  fi
  ;;
set)
  # strip everything but digits so pasted junk can't break the arithmetic
  mins=$(printf '%s' "${2:-}" | tr -cd '0-9')
  mins=$(printf '%s' "$mins" | sed 's/^0*//')
  if [ -z "$mins" ] || [ "$mins" -eq 0 ]; then
    rm -f "$state"
    [ -n "$TMUX" ] && tmux display-message "timer cleared" 2>/dev/null || true
    exit 0
  fi
  printf 'down %s %s\n' "$(now)" "$((mins * 60))" > "$state"
  [ -n "$TMUX" ] && tmux display-message "countdown: ${mins}m" 2>/dev/null || true
  ;;
clear)
  rm -f "$state"
  ;;
line|"" )
  if [ ! -f "$state" ]; then
    printf '#[bg=#525252,fg=#f2f4f8] %s #[default] ' "$(LC_ALL=C date '+%a %d %b')"
    exit 0
  fi
  kind=$(cut -d' ' -f1 < "$state" 2>/dev/null)
  start=$(cut -d' ' -f2 < "$state" 2>/dev/null)
  case "$kind" in
    up)
      start_s=$(( $(now) - ${start:-0} ))
      printf '#[bg=#42be65,fg=#161616] ↑ %s #[default] ' "$(fmt_time "$start_s")"
      ;;
    down)
      dur=$(cut -d' ' -f3 < "$state" 2>/dev/null)
      case "$dur" in ''|*[!0-9]*) dur=0 ;; esac
      remaining=$(( ${start:-0} + dur - $(now) ))
      if [ "$remaining" -le 0 ]; then
        # flash between the two green schemes once a second (status-interval 1)
        if [ $(( $(now) % 2 )) -eq 0 ]; then
          printf '#[bg=#42be65,fg=#161616,bold] 00:00 · TIME UP #[default] '
        else
          printf '#[bg=#161616,fg=#42be65,bold] 00:00 · TIME UP #[default] '
        fi
      else
        printf '#[bg=#33b1ff,fg=#161616] ↓ %s #[default] ' "$(fmt_time "$remaining")"
      fi
      ;;
    *)
      # corrupt state file: drop it and render the idle date instead
      rm -f "$state"
      printf '#[bg=#525252,fg=#f2f4f8] %s #[default] ' "$(LC_ALL=C date '+%a %d %b')"
      ;;
  esac
  ;;
*)
  printf 'usage: %s {toggle|set N|clear|line}\n' "$0" >&2
  exit 1
  ;;
esac
