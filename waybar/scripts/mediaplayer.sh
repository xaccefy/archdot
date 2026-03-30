#!/bin/bash

player_status=$(playerctl status 2>/dev/null)

if [[ "$player_status" == "Playing" || "$player_status" == "Paused" ]]; then
    artist=$(playerctl metadata artist 2>/dev/null | cut -c1-20)
    title=$(playerctl metadata title 2>/dev/null | cut -c1-30)

    if [[ -n "$artist" && -n "$title" ]]; then
        text="$artist - $title"
    elif [[ -n "$title" ]]; then
        text="$title"
    else
        text="unknown"
    fi

    if [[ "$player_status" == "Paused" ]]; then
        text="$text [paused]"
    fi

    echo "{\"text\": \"♪ $text\", \"tooltip\": \"$(playerctl metadata artist 2>/dev/null) - $(playerctl metadata title 2>/dev/null)\", \"class\": \"playing\"}"
else
    echo '{"text": "", "tooltip": "nothing playing", "class": "stopped"}'
fi
