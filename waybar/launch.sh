#!/bin/bash
# Launches waybar with auto-restart, log rotation, and clean error handling.

set -euo pipefail

CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"
LOG_DIR="$HOME/.local/state/waybar"
LOG_FILE="$LOG_DIR/waybar.log"
MAX_LOG_SIZE=$((1024 * 1024))  # 1 MB
MAX_LOG_FILES=3

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
    # Suppress known harmless GTK warnings (libdbusmenu, notifier item conflicts)
    waybar -c "$CONFIG" -s "$STYLE" 2> >(grep -v "LIBDBUSMENU-GLIB-WARNING\|Status Notifier Item.*already registered" >&2) >> "$LOG_FILE"
    exit_code=$?
    # If killed by signal 9 (SIGKILL) or exited 0 (clean quit), don't restart
    if [[ $exit_code -eq 0 || $exit_code -eq 137 ]]; then
        break
    fi
    # Wait before restarting (avoids tight restart loops)
    sleep 1
done
