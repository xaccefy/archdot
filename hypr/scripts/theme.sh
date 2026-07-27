#!/usr/bin/env bash
# theme.sh — switch the Hyprland-native accent theme across hyprlock and waybar.
# (Window borders are left neutral on purpose.)
# Usage: theme.sh {blue|teal|mauve}
#   blue  — current: blue #78a9ff (matches GTK-blue)
#   teal  — oxocarbon teal #08bdba (matches ghostty/starship/fastfetch/rofi)
#   mauve — catppuccin mauve #c6a0f6 (original lockscreen purple)
set -euo pipefail

THEME="${1:-}"
case "$THEME" in
  blue|teal|mauve) ;;
  *) echo "Usage: $0 {blue|teal|mauve}" >&2; exit 1 ;;
esac

# Per-theme values:
#   ACC_RGB -> hyprlock rgba (comma form)
#   ACC_HEX -> waybar @define-color blue/accent
case "$THEME" in
  blue)  ACC_RGB="120, 169, 255"; ACC_HEX="#78a9ff" ;;
  teal)  ACC_RGB="8, 189, 186";   ACC_HEX="#08bdba" ;;
  mauve) ACC_RGB="198, 160, 246"; ACC_HEX="#c6a0f6" ;;
esac

HL="$HOME/.config/hypr/hyprlock.conf"
WB="$HOME/.config/waybar/style.css"

for f in "$HL" "$WB"; do
  [[ -f "$f" ]] || { echo "missing: $f" >&2; exit 1; }
  cp -n "$f" "$f.theme.bak"   # one-time backup, never overwrites
done

# hyprlock accent (solid + alpha)
sed -i -E "s/(\\\$accent_color = rgba\()[0-9]+, [0-9]+, [0-9]+(, 1\.0\))/\1${ACC_RGB}\2/" "$HL"
sed -i -E "s/(\\\$accent_color_alpha = rgba\()[0-9]+, [0-9]+, [0-9]+(, 0\.35\))/\1${ACC_RGB}\2/" "$HL"

# waybar blue + accent
sed -i -E "s/(@define-color blue )#[0-9a-fA-F]{6}/\1${ACC_HEX}/" "$WB"
sed -i -E "s/(@define-color accent )#[0-9a-fA-F]{6}/\1${ACC_HEX}/" "$WB"

# Waybar does NOT hot-reload style.css, so restart it (kill + relaunch) to apply.
# launch.sh handles the clean kill-then-relaunch; the bar comes back automatically.
bash "$HOME/.config/waybar/launch.sh" 2>/dev/null || true

echo "Theme set to: $THEME  (accent ${ACC_HEX})"
