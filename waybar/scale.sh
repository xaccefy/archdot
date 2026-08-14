#!/usr/bin/env bash
# Scale the whole bar. Usage: scale.sh [factor]   e.g. scale.sh 1.2
# With no argument, prints the current factor.
set -euo pipefail

DIR="$HOME/.config/waybar"

if [[ $# -eq 0 ]]; then
    cat "$DIR/.scale" 2>/dev/null || echo "1.0"
    exit 0
fi

FACTOR="$1"
[[ "$FACTOR" =~ ^[0-9]+(\.[0-9]+)?$ ]] || { echo "usage: $0 <factor>  (e.g. 1.2)" >&2; exit 1; }
awk -v s="$FACTOR" 'BEGIN{exit !(s>=0.5 && s<=3.0)}' \
    || { echo "factor must be between 0.5 and 3.0" >&2; exit 1; }

echo "$FACTOR" > "$DIR/.scale"
"$DIR/render.sh"

# SIGUSR2 makes waybar re-read both config.jsonc and style.css in place.
killall -SIGUSR2 waybar 2>/dev/null || true

echo "waybar scale: $FACTOR"
