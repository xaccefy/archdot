#!/usr/bin/env bash
# Toggle the bluetooth radio.
#
# This machine has no bluetooth GUI: no blueman-manager, no
# gnome-control-center, and blueman-applet is not running. So the waybar
# bluetooth module toggles the radio directly instead of popping a terminal
# window. `bluetoothctl power toggle` is not supported by the installed
# bluez, hence the read-then-set.
set -uo pipefail

if bluetoothctl show 2>/dev/null | grep -q 'Powered: yes'; then
    bluetoothctl power off
    notify-send "Bluetooth" "Turned off" -i "bluetooth-disabled" 2>/dev/null || true
else
    bluetoothctl power on
    notify-send "Bluetooth" "Turned on" -i "bluetooth" 2>/dev/null || true
fi
