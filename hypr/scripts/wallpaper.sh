#!/bin/bash
# ponytail: instant wallpaper switch
DIR="$HOME/.config/hypr/wallpapers"
WP=$(find "$DIR" -type f | shuf -n 1)

# Clear cache occasionally to prevent lag
(( RANDOM % 10 == 0 )) && awww clear-cache

# Update AWWW
[[ -f "$WP" ]] && awww img "$WP" --transition-type none --transition-duration 0 --resize crop
