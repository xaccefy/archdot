#!/usr/bin/env bash
# dwm layout symbol for the waybar custom/layout module.
# dwm's bar draws the active layout glyph right after the tags; Button1 on it
# cycles through layouts[] and Button3 jumps to monocle (ClkLtSymbol).
#
# Symbols from the rice's layouts[]: tile "[]=", floating "><>", monocle
# "[M]", grid "HHH". dwindle fills the grid slot -- Hyprland has no grid.
set -u

cur() { hyprctl getoption general:layout -j | /usr/sbin/jq -r .str; }

sym() {
    case "$(cur)" in
        master)  echo "[]=" ;;
        monocle) echo "[M]" ;;
        dwindle) echo "HHH" ;;
        *)       echo "><>" ;;
    esac
}

# hyprctl keyword answers "unknown request" on 0.57 -- Lua eval is the
# supported dynamic-config path.
setlayout() { hyprctl eval "hl.config({ general = { layout = '$1' } })" >/dev/null; }

case "${1:-}" in
    next)
        case "$(cur)" in
            master)  setlayout monocle ;;
            monocle) setlayout dwindle ;;
            *)       setlayout master ;;
        esac ;;
    monocle) setlayout monocle ;;
esac
sym
