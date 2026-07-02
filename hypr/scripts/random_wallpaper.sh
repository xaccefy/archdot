#!/usr/bin/env bash
# ponytail: optimized sequential switch
DIR="$HOME/.config/hypr/wallpapers"
CACHE="$HOME/.cache/current_wallpaper"
LINK="$HOME/.cache/hyprlock_wallpaper"

shopt -s nullglob
FILES=("$DIR"/*.{jpg,jpeg,png,webp})
[[ ${#FILES[@]} -eq 0 ]] && exit 1

CURRENT=$(readlink -f "$LINK" 2>/dev/null)

if [[ "$1" == "restore" ]]; then
    NEXT="$CURRENT"
    [[ -z "$NEXT" ]] && NEXT="${FILES[0]}"
else
    NEXT=""
    for i in "${!FILES[@]}"; do
        if [[ "${FILES[$i]}" == "$CURRENT" ]]; then
            NEXT="${FILES[$(( (i + 1) % ${#FILES[@]} ))]}"
            break
        fi
    done
    [[ -z "$NEXT" ]] && NEXT="${FILES[0]}"
fi

ln -sfn "$NEXT" "$LINK"
echo "$NEXT" > "$CACHE"
awww img "$NEXT" --transition-type none --transition-duration 0 --resize crop
