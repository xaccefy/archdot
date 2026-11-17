#!/usr/bin/env bash
# theme.sh — switch the Hyprland-native accent colour used by hyprlock.
# (Window borders are left neutral on purpose.)
# Usage: theme.sh {dwm|blue|teal|mauve}
#   dwm   — dwm cyan #005577 (default, matches borders/waybar)
#   blue  — desktop accent #78a9ff
#   teal  — oxocarbon teal #08bdba
#   mauve — catppuccin mauve #c6a0f6 (original lockscreen purple)
#
# This used to also rewrite waybar's style.css, seding `@define-color blue` and
# `@define-color accent`. Neither of those colours exists in style.css -- the bar is
# deliberately monochrome (@background/@foreground only) -- so both seds matched nothing,
# yet the script restarted waybar and reported success anyway. The waybar half is gone.
# To re-introduce a themed accent in the bar, add `@define-color accent <hex>;` to
# waybar's styles/style.css, reference it from a rule, then restore a sed here.
set -euo pipefail

THEME="${1:-}"
case "$THEME" in
  dwm|blue|teal|mauve) ;;
  *) echo "Usage: $0 {dwm|blue|teal|mauve}" >&2; exit 1 ;;
esac

# ACC_RGB -> hyprlock rgba (comma form)
case "$THEME" in
  dwm)   ACC_RGB="0, 85, 119";    ACC_HEX="#005577" ;;
  blue)  ACC_RGB="120, 169, 255"; ACC_HEX="#78a9ff" ;;
  teal)  ACC_RGB="8, 189, 186";   ACC_HEX="#08bdba" ;;
  mauve) ACC_RGB="198, 160, 246"; ACC_HEX="#c6a0f6" ;;
esac

HL="$HOME/.config/hypr/hyprlock.conf"
[[ -f "$HL" ]] || { echo "missing: $HL" >&2; exit 1; }
# The palette vars are $accent / $accent_lo (renamed when the lock went
# dwm-flat; the old $accent_color names never existed in this file).
# Vars are column-aligned ("$accent    = rgba(...)"), so match with
# whitespace-tolerant patterns, not fixed strings.
grep -qE '^\$accent[[:space:]]*=[[:space:]]*rgba\('    "$HL" || { echo "missing \$accent in $HL" >&2; exit 1; }
grep -qE '^\$accent_lo[[:space:]]*=[[:space:]]*rgba\(' "$HL" || { echo "missing \$accent_lo in $HL" >&2; exit 1; }

cp -n "$HL" "$HL.theme.bak"   # one-time backup, never overwrites

# hyprlock accent (solid + dim): replace only the RGB triple, keep each alpha.
sed -i -E "s/(\\\$accent[[:space:]]*=[[:space:]]*rgba\()[0-9]+, [0-9]+, [0-9]+/\1${ACC_RGB}/"    "$HL"
sed -i -E "s/(\\\$accent_lo[[:space:]]*=[[:space:]]*rgba\()[0-9]+, [0-9]+, [0-9]+/\1${ACC_RGB}/" "$HL"

# hyprlock re-reads its config on each launch, so there is nothing to reload or restart.
# (The old version ran `bash launch.sh` in the FOREGROUND here. launch.sh is an infinite
# supervisor loop, so theme.sh hung forever, never printed the line below, and left waybar
# re-parented under a throwaway shell.)

echo "Theme set to: $THEME  (hyprlock accent ${ACC_HEX})"
