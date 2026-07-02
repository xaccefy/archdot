#!/bin/bash
pkill -x waybar 2>/dev/null
while pgrep -x waybar >/dev/null; do sleep 0.1; done
waybar -c "$HOME/.config/waybar/config" -s "$HOME/.config/waybar/style.css" > /tmp/waybar.log 2>&1 &
