#!/bin/bash
# Bar/dock style toggle. The active config.jsonc and style.css are rendered from
# configs/ and styles/ by render.sh, which also applies the current .scale factor --
# so switching mode preserves scale, and vice versa.

DIR="$HOME/.config/waybar"
STATE="$DIR/.mode"

# default state
[ ! -f "$STATE" ] && echo "bar" > "$STATE"

MODE=$(cat "$STATE")

if [ "$1" = "toggle" ]; then

    if [ "$MODE" = "bar" ]; then
        echo "dock" > "$STATE"
    else
        echo "bar" > "$STATE"
    fi

    "$DIR/render.sh"
    killall -SIGUSR2 waybar
    exit
fi


if [ "$MODE" = "bar" ]; then
    echo '{"text":"Bar","tooltip":"Switch to dock style"}'
else
    echo '{"text":"Dock","tooltip":"Switch to bar style"}'
fi
