#!/bin/bash
# ponytail: minimal portal sync
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
systemctl --user stop xdg-desktop-portal-hyprland xdg-desktop-portal
systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal
