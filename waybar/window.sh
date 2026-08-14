#!/usr/bin/env bash
# Active-window module for waybar: two-line "class / title" label.
#
# Updates are driven by Hyprland's event socket. The previous version polled
# `hyprctl activewindow` + `hyprctl activeworkspace` every 0.5s forever, i.e. 4-8 process
# spawns per second for the whole session, which is a measurable idle drain on a laptop.

MAX_TITLE_LEN=28

# Match the bar-wide scale factor (see render.sh / scale.sh). These Pango sizes live in a
# script rather than the CSS, so render.sh can't rewrite them -- read the factor directly.
# waybar re-execs this script on SIGUSR2, so a scale change picks up on the next reload.
SCALE=$(cat "$HOME/.config/waybar/.scale" 2>/dev/null || echo 1.0)
[[ "$SCALE" =~ ^[0-9]+(\.[0-9]+)?$ ]] || SCALE=1.0
SZ_TOP=$(awk -v s="$SCALE" 'BEGIN{printf "%d", 8000 * s}')
SZ_BOT=$(awk -v s="$SCALE" 'BEGIN{printf "%d", 9800 * s}')
SZ_RISE=$(awk -v s="$SCALE" 'BEGIN{printf "%d", -2000 * s}')

# Pango-escape via jq's @html. Do NOT use sed for this: in a sed replacement `&` expands to
# the whole match, so the obvious `s/</&lt;/g` emits "<lt;" and leaves `<` unescaped --
# which is invalid markup and makes the module render blank.
esc() { jq -Rr '@html' <<< "$1"; }

print_status() {
    local window address class title app_class top_line bottom_line esc_top esc_bottom text tooltip ws

    window=$(hyprctl activewindow -j 2>/dev/null)
    address=$(jq -r '.address // empty' <<< "$window" 2>/dev/null)

    if [[ -z "$address" || "$address" == "null" ]]; then
        # No active window → show Desktop + Workspace
        ws=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // "?"')
        top_line="Desktop"
        bottom_line="Workspace $ws"
    else
        top_line=$(jq -r '.class // "Unknown"' <<< "$window")
        title=$(jq -r '.title // ""' <<< "$window")

        app_class="${top_line,,}"
        # Discord / Vesktop cleanup
        if [[ "$app_class" == *discord* || "$app_class" == *vesktop* ]]; then
            title=$(sed -E 's/^\([0-9]+\)[[:space:]]*//' <<< "$title")
            title=$(sed -E 's/^Discord[[:space:]]*\|[[:space:]]*//' <<< "$title")
        fi

        # Truncate before escaping, so an entity can never be cut in half.
        if (( ${#title} > MAX_TITLE_LEN )); then
            title="${title:0:$((MAX_TITLE_LEN - 3))}..."
        fi
        bottom_line="$title"
    fi

    esc_top=$(esc "$top_line")
    esc_bottom=$(esc "$bottom_line")

    text="<span size='$SZ_TOP' foreground='#a1a1aa' rise='$SZ_RISE'>$esc_top</span>
<span size='$SZ_BOT' weight='bold' foreground='#f4f4f5'>$esc_bottom</span>"

    if [[ "$top_line" == "Desktop" ]]; then
        tooltip="$bottom_line"
    else
        tooltip="$top_line: $bottom_line"
    fi

    jq -nc --arg text "$text" --arg tooltip "$tooltip" \
        '{ text: $text, class: "custom-window", tooltip: $tooltip }'
}

print_status

SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"

if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" && -S "$SOCK" ]] && command -v socat >/dev/null 2>&1; then
    # Event-driven: block on the socket, redraw only on events that can change the label.
    socat -U - "UNIX-CONNECT:$SOCK" 2>/dev/null | while read -r line; do
        case "$line" in
            activewindow\>\>* | activewindowv2\>\>* | workspace\>\>* | workspacev2\>\>* | \
            windowtitle\>\>* | windowtitlev2\>\>* | closewindow\>\>* | openwindow\>\>* | \
            focusedmon\>\>* | monitorremoved\>\>*)
                print_status
                ;;
        esac
    done
else
    # Fallback: socat missing or not running under Hyprland. Poll, but only redraw on change.
    last=""
    while true; do
        current="$(hyprctl activewindow -j 2>/dev/null)$(hyprctl activeworkspace -j 2>/dev/null)"
        if [[ "$current" != "$last" ]]; then
            print_status
            last="$current"
        fi
        sleep 0.5
    done
fi
