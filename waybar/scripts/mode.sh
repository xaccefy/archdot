#!/usr/bin/env bash
# Layout mode: float (gapped, rounded) or bar (classic full-width).
# Usage: mode.sh [float|bar|status]  -- no argument toggles, status prints the
# waybar-module JSON for custom/mode. Re-renders and reloads waybar on change.
set -euo pipefail

DIR="$HOME/.config/waybar"

cur=$(cat "$DIR/.mode" 2>/dev/null || echo float)
[[ $cur == bar || $cur == float ]] || cur=float

# Module view: the mode as a clickable label. A SIGUSR2 reload re-runs exec, so
# this picks up the new mode without polling.
if [[ ${1:-} == status ]]; then
    printf '{"text":"%s","class":"%s","tooltip":"layout: %s -- click to switch"}\n' \
        "$cur" "$cur" "$cur"
    exit 0
fi

next=${1:-}
if [[ $next != float && $next != bar ]]; then
    next=$( [[ $cur == float ]] && echo bar || echo float )
fi

if [[ $next == $cur ]]; then
    echo "waybar mode: $next (unchanged)"
    exit 0
fi

echo "$next" > "$DIR/.mode"
"$DIR/scripts/render.sh"

# SIGUSR2 makes waybar re-read both config.jsonc and style.css in place.
killall -SIGUSR2 waybar 2>/dev/null || true

echo "waybar mode: $next"
