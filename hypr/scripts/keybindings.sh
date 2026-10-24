#!/bin/bash
# Show the bindings currently loaded by Hyprland.
# Reading hyprctl avoids parsing Lua source and includes generated bindings.

set -o pipefail

python3 <<'PY' | rofi -dmenu -i -p "Keybinds" -theme ~/.config/rofi/launchers/type-1/style-11.rasi
import json
import subprocess
import sys

try:
    binds = json.loads(subprocess.check_output(["hyprctl", "-j", "binds"], text=True))
except (OSError, json.JSONDecodeError) as exc:
    print(f"Unable to read Hyprland binds: {exc}")
    sys.exit(0)

modifiers = ((64, "SUPER"), (4, "CTRL"), (8, "ALT"), (1, "SHIFT"))
seen = set()

for binding in binds:
    description = binding.get("description")
    key = binding.get("key", "")
    if not description or not key:
        continue

    names = [name for bit, name in modifiers if int(binding.get("modmask", 0)) & bit]
    display_key = key
    if binding.get("mouse") and not display_key.startswith("mouse:"):
        display_key = f"mouse:{display_key}"

    line = f"{' + '.join(names + [display_key]):<24} - {description}"
    if line not in seen:
        print(line)
        seen.add(line)
PY
