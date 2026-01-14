#!/bin/bash

# Wallpaper preload script for swww
# Optionally caches all wallpapers for faster switching

WALLPAPER_DIR="$HOME/Pictures"

preload_wallpapers() {
    local wallpaper_dir="${1:-$WALLPAPER_DIR}"

    local wallpapers=($(find "$wallpaper_dir" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f))

    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $wallpaper_dir"
        exit 1
    fi

    for wallpaper in "${wallpapers[@]}"; do
        swww cache "$wallpaper"
    done

    echo "Cached ${#wallpapers[@]} wallpapers for swww"
}

if [ $# -eq 1 ]; then
    preload_wallpapers "$1"
else
    preload_wallpapers
fi
