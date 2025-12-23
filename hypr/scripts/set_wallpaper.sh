#!/bin/bash

# Interactive wallpaper setting script for Hyprland

WALLPAPER_DIR="$HOME/Pictures"

echo "Current wallpaper directory: $WALLPAPER_DIR"
echo "Available wallpapers:"

# List available wallpapers
wallpapers=($(find "$WALLPAPER_DIR" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -type f))

if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Display available wallpapers with numbers
for i in "${!wallpapers[@]}"; do
    filename=$(basename "${wallpapers[$i]}")
    echo "$((i+1)). $filename"
done

echo ""
echo "Enter the number of the wallpaper to set (or 'r' for random):"
read -r choice

if [[ "$choice" == "r" || "$choice" == "R" ]]; then
    # Select random wallpaper
    random_index=$((RANDOM % ${#wallpapers[@]}))
    selected_wallpaper="${wallpapers[$random_index]}"
elif [[ "$choice" =~ ^[0-9]+$ ]]; then
    # Check if the number is valid
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

# Update hyprpaper config
sed -i "s|^preload =.*|preload = $selected_wallpaper|" "$HOME/.config/hypr/hyprpaper.conf"
sed -i "s|^wallpaper =.*|wallpaper = ,$selected_wallpaper|" "$HOME/.config/hypr/hyprpaper.conf"

# Update hyprlock background config
$HOME/.config/hypr/scripts/update_hyprlock_bg.sh "$selected_wallpaper"

# Reload hyprpaper to apply changes
pkill hyprpaper
hyprpaper &

echo "Wallpaper changed to: $selected_wallpaper"