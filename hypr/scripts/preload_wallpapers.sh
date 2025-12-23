#!/bin/bash

# Wallpaper preload script for Hyprpaper
# This script preloads multiple wallpapers in hyprpaper config

WALLPAPER_DIR="$HOME/Pictures"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

preload_wallpapers() {
    local wallpaper_dir="${1:-$WALLPAPER_DIR}"
    
    # Find all image files in the directory
    local wallpapers=($(find "$wallpaper_dir" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $wallpaper_dir"
        exit 1
    fi
    
    # Create a temporary config file
    local temp_config=$(mktemp)
    
    # Copy existing config except preload lines
    grep -v "^preload =" "$HYPRPAPER_CONFIG" > "$temp_config"
    
    # Add preload lines for all wallpapers
    for wallpaper in "${wallpapers[@]}"; do
        echo "preload = $wallpaper" >> "$temp_config"
    done
    
    # If no wallpaper line exists, add the current one
    if ! grep -q "^wallpaper =" "$HYPRPAPER_CONFIG"; then
        echo "wallpaper = ,${wallpapers[0]}" >> "$temp_config"
    else
        # Preserve existing wallpaper line
        grep "^wallpaper =" "$HYPRPAPER_CONFIG" >> "$temp_config"
    fi
    
    # Add other config lines if they exist
    grep -v "^preload =" "$HYPRPAPER_CONFIG" | grep -v "^wallpaper =" >> "$temp_config" || true
    
    # Copy the new config back
    cp "$temp_config" "$HYPRPAPER_CONFIG"
    
    # Clean up
    rm "$temp_config"
    
    # Reload hyprpaper
    pkill hyprpaper
    hyprpaper &
    
    echo "Preloaded ${#wallpapers[@]} wallpapers"
}

if [ $# -eq 1 ]; then
    preload_wallpapers "$1"
else
    preload_wallpapers
fi