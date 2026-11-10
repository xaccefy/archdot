#!/usr/bin/env bash
# Toggle DP-1 (USB-C external) between mirroring eDP-1 and extended above it.
# Hyprland 0.57 has no runtime monitor keyword, so this rewrites the DP-1
# block in monitor.lua and reloads. The choice persists across restarts.
# Usage: monitor.sh [mirror|extend|toggle]   (default: toggle)

CONF="$HOME/.config/hypr/lua/monitor.lua"
OUTPUT="DP-1"
SOURCE="eDP-1"

mode="${1:-toggle}"
case "$mode" in
    mirror|extend|toggle) ;;
    *) echo "usage: $0 [mirror|extend|toggle]" >&2; exit 1 ;;
esac

current=$(/usr/sbin/hyprctl monitors all | /usr/sbin/awk -v out="$OUTPUT" '
    /^Monitor / { name=$2 }
    /mirrorOf:/ { if (name == out) { print $2; exit } }
')

if [[ "$mode" == "toggle" ]]; then
    [[ "$current" == "none" || -z "$current" ]] && mode="mirror" || mode="extend"
fi

/usr/sbin/python3 - "$CONF" "$mode" <<'PY'
import re, sys
conf, mode = sys.argv[1], sys.argv[2]
src = open(conf).read()
pat = re.compile(r'hl\.monitor\(\{.*?\}\)', re.S)
hits = 0

def repl(m):
    global hits
    block = m.group(0)
    if not re.search(r'output\s*=\s*"DP-1"', block):
        return block
    hits += 1
    lines = [l for l in block.splitlines()
             if not re.match(r'\s*(mirror|position)\s*=', l)]
    insert = '    mirror = "eDP-1",' if mode == "mirror" else '    position = "0x-1440",'
    idx = next(i for i, l in enumerate(lines) if l.strip() == "})")
    lines.insert(idx, insert)
    return "\n".join(lines)

new_src = pat.sub(repl, src)
if hits != 1:
    sys.exit("expected 1 DP-1 block, rewrote %d" % hits)
open(conf, "w").write(new_src)
PY

/usr/sbin/hyprctl reload >/dev/null
if [[ "$mode" == "mirror" ]]; then
    msg="$OUTPUT: mirror $SOURCE"
else
    msg="$OUTPUT: extended"
fi
/usr/sbin/notify-send -a Hyprland "Monitor" "$msg"
