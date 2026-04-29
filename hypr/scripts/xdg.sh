#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|
#
# -----------------------------------------------------
sleep 1

systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service 2>/dev/null && exit 0

pkill -x xdg-desktop-portal-hyprland 2>/dev/null
pkill -x xdg-desktop-portal 2>/dev/null
sleep 1

/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
