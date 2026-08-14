#!/usr/bin/env bash
# Now-playing title for waybar.
#
# Two fixes over the old inline `exec` one-liner in config.jsonc:
#  1. The title is Pango-escaped. It wasn't before, so any track containing & < or >
#     produced invalid markup and the module rendered blank.
#  2. The idle state is the plain string "No media" instead of
#     "         No media           ". That space padding was faking a fixed width, so the
#     module changed size on every track change and nudged the whole centre group.
#     Width now comes from `min-width` on #custom-media in CSS, which doesn't reflow.
MAX=25

title=$(playerctl metadata title 2>/dev/null)

if [[ -n "$title" ]]; then
    (( ${#title} > MAX )) && title="${title:0:$((MAX - 3))}..."
    printf '  %s\n' "$(jq -Rr '@html' <<< "$title")"
else
    printf '  No media\n'
fi
