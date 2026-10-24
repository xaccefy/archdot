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
    # Filter BEFORE tee, so the noise is kept out of the log file too. The original
    # had tee first, which appended the unfiltered stream and only filtered the copy
    # going to the terminal -- i.e. it filtered nothing that anyone ever read.
    exit_code=0
    waybar -c "$CONFIG" -s "$STYLE" \
        >> "$LOG_FILE" \
        2> >(grep -vE --line-buffered "$NOISE" | tee -a "$LOG_FILE" >&2) \
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
