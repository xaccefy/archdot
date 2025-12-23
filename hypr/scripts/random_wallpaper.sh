#!/bin/bash

# Random wallpaper script for Hyprland

WALLPAPER_DIR="$HOME/Pictures"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Function to select and set random wallpaper
set_random_wallpaper() {
    local wallpaper_dir="${1:-$WALLPAPER_DIR}"
    
    # Find all image files in the directory
    local wallpapers=($(find "$wallpaper_dir" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $wallpaper_dir"
        exit 1
    fi
    
    # Select a random wallpaper
    local random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
    
    echo "Selected wallpaper: $random_wallpaper"
    
    # Update hyprpaper config
    sed -i "s|^preload =.*|preload = $random_wallpaper|" "$HYPRPAPER_CONFIG"
    sed -i "s|^wallpaper =.*|wallpaper = ,$random_wallpaper|" "$HYPRPAPER_CONFIG"

    # Update hyprlock background config
    $HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$random_wallpaper"

    # Reload hyprpaper to apply changes
    pkill hyprpaper
    hyprpaper &
    
    echo "Wallpaper changed to: $random_wallpaper"
}

# If script is called with an argument, use that as the directory
if [ $# -eq 1 ]; then
    set_random_wallpaper "$1"
else
    set_random_wallpaper
fi