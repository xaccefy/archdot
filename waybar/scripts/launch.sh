#!/bin/bash
# Launches waybar with auto-restart, log rotation, and clean error handling.

# NOTE: deliberately no `set -e`. With -e, the shell exited the moment waybar
# returned non-zero, so `exit_code=$?` and the entire restart block below were
# unreachable -- the auto-restart this script exists for never actually ran.
set -uo pipefail

CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"
LOG_DIR="$HOME/.local/state/waybar"
LOG_FILE="$LOG_DIR/waybar.log"
MAX_LOG_SIZE=$((1024 * 1024))  # 1 MB
MAX_LOG_FILES=3

# Known-harmless chatter emitted once a minute by the tray; filtered out of the log.
NOISE='LIBDBUSMENU-GLIB-WARNING|Status Notifier Item.*already registered'

mkdir -p "$LOG_DIR"

# Single-instance lock. Waybar is autostarted from two places (Hyprland's
# autostart.lua and waybar.service), and the loser previously spun forever in
# the pgrep wait below, then respawned waybar after an intentional kill.
# Now the loser exits here instead; the lock releases when this script dies,
# so a later launch can still take over.
exec 9>"$LOG_DIR/.launch.lock"
flock -n 9 || exit 0

# Rotate logs if current log exceeds max size
rotate_logs() {
    if [[ -f "$LOG_FILE" && $(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0) -gt $MAX_LOG_SIZE ]]; then
        for i in $(seq $((MAX_LOG_FILES - 1)) -1 1); do
            src="$LOG_FILE.$i"
            dst="$LOG_FILE.$((i + 1))"
            [[ -f "$src" ]] && mv -f "$src" "$dst"
        done
        mv -f "$LOG_FILE" "$LOG_FILE.1"
        # Truncate the active log
        : > "$LOG_FILE"
    fi
}

rotate_logs

# Kill any existing waybar gracefully
pkill -x waybar 2>/dev/null || true
sleep 0.2
while pgrep -x waybar >/dev/null 2>&1; do sleep 0.1; done

# Launch loop: restart waybar if it exits unexpectedly
while true; do
    # stdout carries waybar's spdlog output (all real logging) PLUS a
    # puts(status) leftover in waybar 0.15.0's battery module that prints
    # "Charging"/"Full"/blank lines at every power_supply uevent (~25k lines
    # in three weeks; fixed upstream after 0.15.0). Keeping only [timestamped]
    # lines drops the spam while preserving the log.
    # stderr goes through the NOISE filter -> tee -> log + terminal.
    # 9>&- keeps waybar from inheriting the launch lock fd.
    exit_code=0
    waybar -c "$CONFIG" -s "$STYLE" \
        > >(grep -aE --line-buffered '^\[' >> "$LOG_FILE") \
        2> >(grep -vE --line-buffered "$NOISE" | tee -a "$LOG_FILE" >&2) \
        9>&- \
        || exit_code=$?

    # 0   = clean quit
    # 137 = SIGKILL, 143 = SIGTERM -- someone killed it on purpose (another launch.sh
    #       taking over, or SUPER+SHIFT+B). Resurrecting it here would fight them.
    case $exit_code in
        0|137|143) break ;;
    esac

    printf '[%s] waybar exited %d -- restarting\n' "$(date '+%F %T')" "$exit_code" >> "$LOG_FILE"
    # Wait before restarting (avoids tight restart loops)
    sleep 1
    rotate_logs
done
