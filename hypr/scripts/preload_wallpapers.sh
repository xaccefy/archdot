#!/bin/bash

# Wallpaper preload script for awww
# awww manages its own cache after images are displayed, so there is nothing to preload.

WALLPAPER_DIR="$HOME/Pictures"

preload_wallpapers() {
    local wallpaper_dir="${1:-$WALLPAPER_DIR}"

    local wallpaper_count
    wallpaper_count=$(find "$wallpaper_dir" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f | wc -l)

    if [ "$wallpaper_count" -eq 0 ]; then
        echo "No wallpapers found in $wallpaper_dir"
        exit 1
    fi

    echo "awww does not support manual preloading. Cache will be created as wallpapers are displayed."
}

if [ $# -eq 1 ]; then
    preload_wallpapers "$1"
else
    preload_wallpapers
fi
