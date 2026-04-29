#!/bin/bash

WALLPAPER_PATH="$1"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Wallpaper file does not exist: $WALLPAPER_PATH"
    exit 1
fi

if [ ! -f "$HYPRLOCK_CONFIG" ]; then
    echo "Hyprlock config does not exist: $HYPRLOCK_CONFIG"
    exit 1
fi

python - "$HYPRLOCK_CONFIG" "$WALLPAPER_PATH" <<'PY'
from pathlib import Path
import sys

config = Path(sys.argv[1])
wallpaper = sys.argv[2]
lines = config.read_text().splitlines()
in_background = False
updated = False

for index, line in enumerate(lines):
    stripped = line.strip()
    if stripped == "background {":
        in_background = True
        continue
    if in_background and stripped == "}":
        in_background = False
        continue
    if in_background and stripped.startswith("path ="):
        indent = line[:len(line) - len(line.lstrip())]
        lines[index] = f"{indent}path = {wallpaper}"
        updated = True
        break

if not updated:
    raise SystemExit("No background path found in hyprlock config")

config.write_text("\n".join(lines) + "\n")
PY
