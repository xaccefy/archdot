#!/usr/bin/env bash
set -euo pipefail

image_file=$(mktemp --suffix=.clipboard-image)
trap 'rm -f "$image_file"' EXIT
cat > "$image_file"
cliphist store < "$image_file"

mime=$(file --brief --mime-type "$image_file")
case "$mime" in
    image/*)
        notify-send --app-name=Clipboard --icon="$image_file" "Image copied" "$mime"
        ;;
esac
