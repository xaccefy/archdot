#!/bin/bash

CURRENT_WALLPAPER_CACHE="$HOME/.cache/current_wallpaper"
DEFAULT_WALLPAPER_DIR="$HOME/Pictures"

sleep 1

if [ -f "$CURRENT_WALLPAPER_CACHE" ]; then
    cached_wallpaper=$(cat "$CURRENT_WALLPAPER_CACHE")
    if [ -f "$cached_wallpaper" ]; then
        exec awww img "$cached_wallpaper" --transition-type none --transition-duration 0 --resize crop
    fi
fi

if awww restore >/dev/null 2>&1; then
    exit 0
fi

first_wallpaper=""
while IFS= read -r -d $'\0' wallpaper; do
    first_wallpaper="$wallpaper"
    break
done < <(find "$DEFAULT_WALLPAPER_DIR" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f -print0 | sort -z)

if [ -n "$first_wallpaper" ]; then
    exec awww img "$first_wallpaper" --transition-type none --transition-duration 0 --resize crop
fi
