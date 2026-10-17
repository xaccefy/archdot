#!/bin/bash
# Keep the user systemd and session D-Bus environments in sync with Hyprland.
# Only desktop/session variables are imported; unrelated exported variables
# (including tokens and secrets) are intentionally left out.

# Keep these defaults in sync with lua/environment.lua when the script is run
# outside a Hyprland-started process (for example, from a terminal).
export GTK_THEME="Graphite-blue-Dark-compact"
export XCURSOR_THEME="Bibata-Modern-Ice"
export XCURSOR_SIZE="25"
export HYPRCURSOR_THEME="Bibata-Original-Classic-Hypr" # no Modern-Ice Hyprcursor variant installed
export HYPRCURSOR_SIZE="25"
export ELECTRON_OZONE_PLATFORM_HINT="auto"
export OZONE_PLATFORM="auto"

SESSION_VARS=(
  WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_RUNTIME_DIR DISPLAY
  GTK_THEME GDK_BACKEND QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE
  ELECTRON_OZONE_PLATFORM_HINT OZONE_PLATFORM
  XCURSOR_THEME XCURSOR_SIZE HYPRCURSOR_THEME HYPRCURSOR_SIZE
)

systemctl --user import-environment "${SESSION_VARS[@]}"
dbus-update-activation-environment "${SESSION_VARS[@]}"
systemctl --user stop xdg-desktop-portal-hyprland xdg-desktop-portal
systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal
