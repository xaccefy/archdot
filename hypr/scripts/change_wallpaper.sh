#!/bin/bash

# Wallpaper changing script for Hyprland

WALLPAPER_DIR="$HOME/Pictures"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Function to change wallpaper
change_wallpaper() {
    local wallpaper_path="$1"

    if [ ! -f "$wallpaper_path" ]; then
        echo "Wallpaper file does not exist: $wallpaper_path"
        exit 1
    fi

    # Update hyprpaper config
    sed -i "s|^preload =.*|preload = $wallpaper_path|" "$HYPRPAPER_CONFIG"
    sed -i "s|^wallpaper =.*|wallpaper = ,$wallpaper_path|" "$HYPRPAPER_CONFIG"

    # Update hyprlock background config
    $HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$wallpaper_path"

    # Reload hyprpaper to apply changes
    pkill hyprpaper
    hyprpaper &
}

# If script is called with an argument, use that as the wallpaper
if [ $# -eq 1 ]; then
    change_wallpaper "$1"
else
    echo "Usage: $0 <wallpaper_path>"
    echo "Example: $0 ~/Pictures/new_wallpaper.jpg"
    exit 1
fi