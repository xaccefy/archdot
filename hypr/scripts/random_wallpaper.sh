#!/bin/bash

# Sequential wallpaper script for Hyprland (swww)
# Modified to cycle through wallpapers one by one instead of random selection

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/.config/wallpapers}"
CACHE_FILE="$HOME/.cache/current_wallpaper"
SWWW_FLAGS=("--transition-type" "none" "--transition-duration" "0" "--resize" "crop")

if [ ! -d "$WALLPAPER_DIR" ]; then
    WALLPAPER_DIR="$HOME/Pictures"
fi

# Ensure cache directory exists
mkdir -p "$(dirname "$CACHE_FILE")"

cycle_wallpaper() {
    local wallpaper_dir="${1:-$WALLPAPER_DIR}"
    
    # Get sorted list of wallpapers to ensure consistent order
    local wallpapers=($(find "$wallpaper_dir" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f | sort))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $wallpaper_dir"
        exit 1
    fi

    # Read the last used wallpaper
    local current_wallpaper=""
    if [ -f "$CACHE_FILE" ]; then
        current_wallpaper=$(cat "$CACHE_FILE")
    fi

    local next_index=0
    
    # Find index of current wallpaper to determine the next one
    for i in "${!wallpapers[@]}"; do
        if [ "${wallpapers[$i]}" == "$current_wallpaper" ]; then
            next_index=$(( (i + 1) % ${#wallpapers[@]} ))
            break
        fi
    done

    local selected_wallpaper="${wallpapers[$next_index]}"
    
    echo "Selected wallpaper: $selected_wallpaper"
    
    swww img "$selected_wallpaper" "${SWWW_FLAGS[@]}"

    # Save selected wallpaper to cache
    echo "$selected_wallpaper" > "$CACHE_FILE"

    $HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$selected_wallpaper"
    
    echo "Wallpaper changed to: $selected_wallpaper"
}

if [ $# -eq 1 ]; then
    cycle_wallpaper "$1"
else
    cycle_wallpaper
fi
