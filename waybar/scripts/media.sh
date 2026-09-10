#!/usr/bin/env bash
# Now-playing title for waybar.
#
# Event-driven: `playerctl -F` blocks and emits a line on every metadata change
# (and once at startup), and waybar updates the module per output line. The old
# version polled every 2s instead, spawning playerctl forever.
#
#  1. The title is Pango-escaped. It wasn't before, so any track containing & < or >
#     produced invalid markup and the module rendered blank.
#  2. The idle state is the plain string "No media" instead of
#     "         No media           ". That space padding was faking a fixed width, so the
#     module changed size on every track change and nudged the whole centre group.
#     Width now comes from `min-width` on #custom-media in CSS, which doesn't reflow.
MAX=25

show() {
    local title=$1
    if [[ -z "$title" || "$title" == "(No players)" || "$title" == "No players found" ]]; then
        printf '  No media\n'
        return
    fi
    (( ${#title} > MAX )) && title="${title:0:$((MAX - 3))}..."
    printf '  %s\n' "$(jq -Rr '@html' <<< "$title")"
}

# Initial state, printed once: -F only emits on changes, and a player like Chrome's
# MPRIS stub never reports metadata, so without this the module would stay blank.
show "$(playerctl metadata title 2>/dev/null)"

# stdbuf -oL: playerctl block-buffers when piped, which would sit on the first line.
stdbuf -oL playerctl -F metadata -f '{{title}}' 2>/dev/null |
    while IFS= read -r line; do show "$line"; done
