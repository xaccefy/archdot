#!/usr/bin/env bash
# ponytail: optimized sequential switch
DIR="$HOME/.config/hypr/wallpapers"
CACHE="$HOME/.cache/current_wallpaper"
LINK="$HOME/.cache/hyprlock_wallpaper"

shopt -s nullglob
FILES=("$DIR"/*.{jpg,jpeg,png,webp})
[[ ${#FILES[@]} -eq 0 ]] && exit 1

# Only consider actual image files — skip symlinks to non-images or
# non-image files accidentally placed in the wallpaper directory.
IMAGES=()
for f in "${FILES[@]}"; do
    [[ -f "$f" ]] && IMAGES+=("$f")
done
[[ ${#IMAGES[@]} -eq 0 ]] && exit 1
FILES=("${IMAGES[@]}")

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
