#!/bin/bash

# Wallpaper changing script for Hyprland (swww)

WALLPAPER_DIR="$HOME/Pictures"
SWWW_FLAGS=("--transition-type" "none" "--transition-duration" "0" "--resize" "crop")

change_wallpaper() {
    local wallpaper_path="$1"

    if [ ! -f "$wallpaper_path" ]; then
        echo "Wallpaper file does not exist: $wallpaper_path"
        exit 1
    fi

    swww img "$wallpaper_path" "${SWWW_FLAGS[@]}"

    $HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$wallpaper_path"
}

if [ $# -eq 1 ]; then
    change_wallpaper "$1"
else
    echo "Usage: $0 <wallpaper_path>"
    echo "Example: $0 ~/Pictures/new_wallpaper.jpg"
    exit 1
fi
