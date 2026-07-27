#!/usr/bin/env bash
# timer.sh - Countdown timer for waybar
# Scroll up/down to add/remove minutes. Auto-starts. Click toggles pause.
# Uses flock to prevent race conditions on concurrent invocations.

TIMER_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-timer"
LOCK_FILE="${TIMER_FILE}.lock"

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    # Another instance holds the lock — wait briefly then retry once
    flock -w 1 9 || exit 0
fi

cleanup() { rm -f "$LOCK_FILE"; }
trap cleanup EXIT

case "${1:-}" in
    +*)
        inc=${1#+}
        if [ -f "$TIMER_FILE" ]; then
            content=$(cat "$TIMER_FILE")
            case "$content" in
                -*)
                    # paused: stored as negative remaining
                    remaining=${content#-}
                    remaining=$((remaining + inc))
                    echo "-$remaining" > "$TIMER_FILE"
                    ;;
                *)
                    end=$content
                    now=$(date +%s)
                    remaining=$((end - now))
                    [ "$remaining" -lt 0 ] && remaining=0
                    remaining=$((remaining + inc))
                    echo "$((now + remaining))" > "$TIMER_FILE"
                    ;;
            esac
        else
            echo "$(($(date +%s) + inc))" > "$TIMER_FILE"
        fi
        ;;
    -*)
        dec=${1#-}
        if [ -f "$TIMER_FILE" ]; then
            content=$(cat "$TIMER_FILE")
            case "$content" in
                -*)
                    remaining=${content#-}
                    remaining=$((remaining - dec))
                    [ "$remaining" -lt 0 ] && remaining=0
                    if [ "$remaining" -gt 0 ]; then
                        echo "-$remaining" > "$TIMER_FILE"
                    else
                        rm -f "$TIMER_FILE"
                    fi
                    ;;
                *)
                    end=$content
                    now=$(date +%s)
                    remaining=$((end - now))
                    [ "$remaining" -lt 0 ] && remaining=0
                    remaining=$((remaining - dec))
                    [ "$remaining" -lt 0 ] && remaining=0
                    if [ "$remaining" -gt 0 ]; then
                        echo "$((now + remaining))" > "$TIMER_FILE"
                    else
                        rm -f "$TIMER_FILE"
                    fi
                    ;;
            esac
        fi
        ;;
    toggle)
        if [ -f "$TIMER_FILE" ]; then
            content=$(cat "$TIMER_FILE")
            case "$content" in
                -*)
                    # paused -> resume by converting back to end timestamp
                    remaining=${content#-}
                    echo "$(($(date +%s) + remaining))" > "$TIMER_FILE"
                    ;;
                *)
                    end=$content
                    now=$(date +%s)
                    remaining=$((end - now))
                    [ "$remaining" -lt 0 ] && remaining=0
                    if [ "$remaining" -gt 0 ]; then
                        echo "-$remaining" > "$TIMER_FILE"
                    else
                        rm -f "$TIMER_FILE"
                    fi
                    ;;
            esac
        fi
        ;;
    reset)
        rm -f "$TIMER_FILE"
        ;;
    *)
        if [ -f "$TIMER_FILE" ]; then
            content=$(cat "$TIMER_FILE")
            case "$content" in
                -*)
                    remaining=${content#-}
                    mins=$((remaining / 60))
                    secs=$((remaining % 60))
                    printf '{"text": "%02d:%02d", "class": "paused"}\n' "$mins" "$secs"
                    ;;
                *)
                    end=$content
                    now=$(date +%s)
                    remaining=$((end - now))
                    if [ "$remaining" -gt 0 ]; then
                        mins=$((remaining / 60))
                        secs=$((remaining % 60))
                        printf '{"text": "%02d:%02d", "class": "running"}\n' "$mins" "$secs"
                    else
                        rm -f "$TIMER_FILE"
                        printf '{"text": "00:00", "class": "done"}\n'
                    fi
                    ;;
            esac
        else
            printf '{"text": "timer", "class": "stopped"}\n'
        fi
        ;;
esac
