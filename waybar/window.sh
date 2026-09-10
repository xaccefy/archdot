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
read -r SZ_TOP SZ_BOT SZ_RISE <<< "$(awk -v s="$SCALE" 'BEGIN{printf "%d %d %d", 8000*s, 9800*s, -2000*s}')"

# Pango-escape via jq's @html. Do NOT use sed for this: in a sed replacement `&` expands to
# the whole match, so the obvious `s/</&lt;/g` emits "<lt;" and leaves `<` unescaped --
# which is invalid markup and makes the module render blank.
esc() { jq -Rr '@html' 2>/dev/null <<< "$1"; }

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
        # Discord-family cleanup (Discord / Vesktop / WebCord). WebCord titles look like
        # "[1] WebCord - #channel (server)"; strip the unread count and the app name so
        # the label shows just the channel instead of repeating the class.
        if [[ "$app_class" == *discord* || "$app_class" == *vesktop* || "$app_class" == *webcord* ]]; then
            title=$(sed -E 's/^(\([0-9]+\)|\[[0-9]+\])[[:space:]]*//' <<< "$title")
            title=$(sed -E 's/^(Discord|WebCord)[[:space:]]*[|-][[:space:]]*//' <<< "$title")
        fi
        # Prettify the bare class for the apps whose class is lowercase branding.
        [[ "$app_class" == webcord ]] && top_line="WebCord"

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
        '{ text: $text, class: "custom-window", tooltip: $tooltip }' 2>/dev/null || true
}

print_status

SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"

# Events that can change the active-window/workspace label.
EVENT_RE='activewindow>>|activewindowv2>>|workspace>>|workspacev2>>|windowtitle>>|windowtitlev2>>|closewindow>>|openwindow>>|focusedmon>>|monitorremoved>>'

have_events() {
    [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" && -S "$SOCK" ]] && command -v socat >/dev/null 2>&1
}

# One outer loop so a vanished compositor is a detour, not a dead end: poll while
# Hyprland is gone, and re-attach to the event socket as soon as it comes back.
last=""
poll_delay=0.5

while true; do
    if have_events; then
        poll_delay=0.5
        # Event-driven: block on the socket, redraw only on events that can change the label.
        # The socket2 connection can drop (compositor reload, transient socat failure). Without
        # a reconnect loop the script would exit once, and waybar -- which spawned this script
        # only once via plain `exec` -- would freeze the module on stale output forever. Wrap
        # the reader in a loop so a dropped connection reconnects instead of killing us.
        # Do NOT `set -o pipefail` here: socat closing its stdout (normal EOF) would otherwise
        # make the whole pipeline return non-zero and abort the outer loop on the first drop.
        while true; do
            socat -U - "UNIX-CONNECT:$SOCK" 2>/dev/null | while IFS= read -r line; do
                if [[ "$line" =~ $EVENT_RE ]]; then
                    print_status
                fi
            done
            # Socket dropped. Refresh once so a stale label doesn't linger during the gap,
            # then back off briefly so we don't spin if the compositor is gone for good.
            print_status
            sleep 0.5
            # Socket vanished entirely (Hyprland exited) -> drop to the poll loop below.
            [[ -S "$SOCK" ]] || break
        done
    fi

    # Fallback: socat missing, not under Hyprland, or socket currently gone. Poll,
    # but only redraw on change. While Hyprland answers, poll fast; while it's gone,
    # ease off up to 5s instead of spawning two failing hyprctl calls twice a second
    # forever. When the socket reappears, the next iteration re-attaches to events.
    current="$(hyprctl activewindow -j 2>/dev/null)$(hyprctl activeworkspace -j 2>/dev/null)"
    if [[ -n "$current" ]]; then
        poll_delay=0.5
    else
        poll_delay=$(awk -v d="$poll_delay" 'BEGIN { d *= 2; printf "%g", (d > 5 ? 5 : d) }')
    fi
    if [[ "$current" != "$last" ]]; then
        print_status
        last="$current"
    fi
    sleep "$poll_delay"
done
