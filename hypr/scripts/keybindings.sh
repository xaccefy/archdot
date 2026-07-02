#!/bin/bash
# ponytail: clean dynamic keybinds from lua
python3 << 'EOF' | rofi -dmenu -i -p "Keybinds" -theme ~/.config/rofi/launchers/type-1/style-11.rasi
import re, sys, os
filepath = os.path.expanduser("~/.config/hypr/lua/keybinding.lua")
with open(filepath, "r") as f:
    content = f.read()
bind_re = re.compile(r"hl\.bind\((.+)\)")
for line in content.splitlines():
    line = line.strip()
    if not line.startswith("hl.bind"):
        continue
    match = bind_re.match(line)
    if not match:
        continue
    args_str = match.group(1)
    parts = []
    current = []
    depth = 0
    in_quotes = False
    quote_char = None
    i = 0
    while i < len(args_str):
        c = args_str[i]
        if in_quotes:
            if c == quote_char and (i == 0 or args_str[i-1] != "\\"):
                in_quotes = False
            current.append(c)
        else:
            if c in ["\"", "\'"]:
                in_quotes = True
                quote_char = c
                current.append(c)
            elif c in ["(", "[", "{"]:
                depth += 1
                current.append(c)
            elif c in [")", "]", "}"]:
                depth -= 1
                current.append(c)
            elif c == "," and depth == 0:
                parts.append("".join(current).strip())
                current = []
            else:
                current.append(c)
        i += 1
    if current:
        parts.append("".join(current).strip())
    if len(parts) < 2:
        continue
    keys = parts[0].replace("mainMod .. ", "SUPER").replace("\"", "").replace("\'", "").replace(" .. ", "").strip()
    keys = re.sub(r"\s*\+\s*", " + ", keys)
    action_raw = parts[1]
    opts_raw = parts[2] if len(parts) > 2 else ""
    desc = None
    if opts_raw:
        desc_match = re.search(r"desc\s*=\s*\[?\[?[\"\'](.*?)[\"\']\]?\]?", opts_raw)
        if desc_match:
            desc = desc_match.group(1)
    if not desc:
        cmd_match = re.search(r"exec_cmd\(\[?\[?[\"\'](.*?)[\"\']\]?\]?\)", action_raw)
        if cmd_match:
            desc = cmd_match.group(1)
        elif "window.close" in action_raw:
            desc = "Kill active window"
        elif "window.fullscreen" in action_raw:
            desc = "Toggle fullscreen"
        elif "window.float" in action_raw:
            desc = "Toggle floating mode"
        elif "window.drag" in action_raw:
            desc = "Move window with mouse"
        elif "window.resize" in action_raw:
            desc = "Resize window with mouse"
        elif "focus" in action_raw:
            dir_match = re.search(r"direction\s*=\s*[\"\'](.*?)[\"\']", action_raw)
            ws_match = re.search(r"workspace\s*=\s*[\"\']?(.*?)[\"\']?", action_raw)
            if dir_match:
                desc = f"Focus window {dir_match.group(1)}"
            elif ws_match:
                desc = f"Focus workspace {ws_match.group(1)}"
            else:
                desc = "Change Focus"
        elif "move" in action_raw:
            dir_match = re.search(r"direction\s*=\s*[\"\'](.*?)[\"\']", action_raw)
            ws_match = re.search(r"workspace\s*=\s*[\"\']?(.*?)[\"\']?", action_raw)
            if dir_match:
                desc = f"Move window {dir_match.group(1)}"
            elif ws_match:
                desc = f"Move window to workspace {ws_match.group(1)}"
            else:
                desc = "Move window"
        elif "layout" in action_raw:
            desc = "Toggle layout/splitting"
        else:
            desc = action_raw.replace("hl.dsp.", "")
    print(f"{keys:<22} - {desc}")
EOF
