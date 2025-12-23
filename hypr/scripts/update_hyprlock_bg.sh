#!/bin/bash

# Script to update hyprlock background configuration
# For TUI mode, we keep the solid color background

WALLPAPER_PATH="$1"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Wallpaper file does not exist: $WALLPAPER_PATH"
    exit 1
fi

# For TUI mode, we keep the solid color background
# We'll comment out the automatic background change and just notify user
echo "Note: TUI mode uses a solid color background. To change background, manually edit $HYPRLOCK_CONFIG"