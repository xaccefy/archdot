#!/bin/bash

# Random wallpaper script for Hyprland (swww)

WALLPAPER_DIR="$HOME/Pictures"
SWWW_FLAGS=("--transition-type" "none" "--transition-duration" "0" "--resize" "crop")

set_random_wallpaper() {
    local wallpaper_dir="${1:-$WALLPAPER_DIR}"
    
    local wallpapers=($(find "$wallpaper_dir" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $wallpaper_dir"
        exit 1
    fi
    
    local random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
    
    echo "Selected wallpaper: $random_wallpaper"
    
    swww img "$random_wallpaper" "${SWWW_FLAGS[@]}"

    $HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$random_wallpaper"
    
    echo "Wallpaper changed to: $random_wallpaper"
}

if [ $# -eq 1 ]; then
    set_random_wallpaper "$1"
else
    set_random_wallpaper
fi
