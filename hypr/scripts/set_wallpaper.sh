#!/bin/bash

# Interactive wallpaper setting script for Hyprland (swww)

WALLPAPER_DIR="$HOME/Pictures"
SWWW_FLAGS=("--transition-type" "none" "--transition-duration" "0" "--resize" "crop")

echo "Current wallpaper directory: $WALLPAPER_DIR"
echo "Available wallpapers:"

wallpapers=($(find "$WALLPAPER_DIR" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f))

if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

for i in "${!wallpapers[@]}"; do
    filename=$(basename "${wallpapers[$i]}")
    echo "$((i+1)). $filename"
done

echo ""
echo "Enter the number of the wallpaper to set (or 'r' for random):"
read -r choice

if [[ "$choice" == "r" || "$choice" == "R" ]]; then
    random_index=$((RANDOM % ${#wallpapers[@]}))
    selected_wallpaper="${wallpapers[$random_index]}"
elif [[ "$choice" =~ ^[0-9]+$ ]]; then
    if (( choice >= 1 && choice <= ${#wallpapers[@]} )); then
        selected_wallpaper="${wallpapers[$((choice-1))]}"
    else
        echo "Invalid number. Please enter a number between 1 and ${#wallpapers[@]}"
        exit 1
    fi
else
    echo "Invalid input. Please enter a number or 'r' for random."
    exit 1
fi

echo "Setting wallpaper: $selected_wallpaper"

swww img "$selected_wallpaper" "${SWWW_FLAGS[@]}"

$HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$selected_wallpaper"

echo "Wallpaper changed to: $selected_wallpaper"
