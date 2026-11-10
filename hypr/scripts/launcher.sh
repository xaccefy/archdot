#!/usr/bin/env bash
# Unified launcher: apps, shell commands, ssh hosts and files in one fuzzy list.
# Session tools (clipboard, screenshots, keybinds, lock, wallpaper, accent
# themes) appear as entries via ~/.local/share/applications/hypr-*.desktop.
# Window switching is intentionally excluded: rofi's window mode relies on
# wmctrl/EWMH, which cannot focus native Wayland windows under Hyprland.
exec rofi -show combi -replace -i \
    -modes combi \
    -combi-modes "drun,run,ssh,filebrowser" \
    -theme "$HOME/.config/rofi/launchers/type-1/glass-compact.rasi"
