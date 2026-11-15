#!/usr/bin/env bash
# Layout mode: float (gapped, rounded) or bar (classic full-width).
# Usage: mode.sh [float|bar]  -- no argument toggles. Re-renders and reloads
# waybar on change.
set -euo pipefail

DIR="$HOME/.config/waybar"

cur=$(cat "$DIR/.mode" 2>/dev/null || echo float)
[[ $cur == bar || $cur == float ]] || cur=float

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
