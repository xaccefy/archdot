#!/bin/bash
item=$(cliphist list | rofi -dmenu -replace -theme ~/.config/rofi/launchers/type-1/style-11.rasi)
[[ -n "$item" ]] && echo "$item" | cliphist decode | wl-copy
