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

# Resolve the current wallpaper to a real path. ~/.config/hypr is a symlink
# into the dotfiles repo, so the path recorded in the cache is not the same
# string as its fully resolved form. Both sides of the comparison are
# resolved here; comparing a resolved path against the unresolved entries in
# FILES never matches, which made the cycle fall back to the first file on
# every press.
CURRENT=$(readlink -f "$LINK" 2>/dev/null)

CURRENT_INDEX=-1
for i in "${!FILES[@]}"; do
    if [[ "$(readlink -f -- "${FILES[$i]}")" == "$CURRENT" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

if [[ "$1" == "restore" ]]; then
    if (( CURRENT_INDEX >= 0 )); then
        NEXT="${FILES[$CURRENT_INDEX]}"
    else
        NEXT="${FILES[0]}"
    fi
else
    if (( CURRENT_INDEX >= 0 )); then
        NEXT="${FILES[$(( (CURRENT_INDEX + 1) % ${#FILES[@]} ))]}"
    else
        NEXT="${FILES[0]}"
    fi
fi

ln -sfn "$NEXT" "$LINK"
echo "$NEXT" > "$CACHE"
awww img "$NEXT" --transition-type none --transition-duration 0 --resize crop

# Border accent disabled (fixed white border). Re-enable by uncommenting:
# ~/.config/hypr/scripts/wallpaper-accent.sh || true
