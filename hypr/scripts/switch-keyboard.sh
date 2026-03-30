#!/bin/bash
# Simple script to toggle between US and Mongolian keyboard layouts
# Uses the built-in keyboard layout toggle

setxkbmap -layout us,mn -option grp:win_space_toggle
xdotool key Shift_L