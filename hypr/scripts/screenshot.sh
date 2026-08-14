#!/bin/bash
# ponytail: grimblast menu with window detection
options="Area\nScreen\nActive Window\nArea (edit)\nScreen (delay)\nScreen (edit)"
choice=$(echo -e "$options" | rofi -dmenu -i -p "screenshot" -theme ~/.config/rofi/launchers/type-1/glass-screenshot.rasi -l 6)

[[ -z "$choice" ]] && exit 0
sleep 0.2 # Wait for rofi to fade

case $choice in
    "Area")           
        grimblast copy area && notify-send "Screenshot" "Area copied to clipboard" ;;
    
    "Screen")         
        grimblast copy output && notify-send "Screenshot" "Fullscreen copied to clipboard" ;;

    "Active Window")
        read -r x y < <(hyprctl cursorpos | tr -d ',')
        ws=$(hyprctl activeworkspace -j | jq -r .id)
        # `last` on an empty array yields null, and interpolating null produced the literal
        # text "null,null nullxnull" -- never the string "null" -- so the old
        # [[ "$geom" != "null" ]] test was always true and the else branch was unreachable.
        # Emit nothing when no window matches, and test for empty instead.
        geom=$(hyprctl clients -j | jq -r "[.[] | select(.workspace.id == $ws and .at[0] <= $x and .at[0] + .size[0] >= $x and .at[1] <= $y and .at[1] + .size[1] >= $y)] | last | if . == null then empty else \"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\" end")

        if [[ -n "$geom" ]]; then
            grimblast copy area "$geom" && notify-send "Screenshot" "Active window copied"
        else
            notify-send "Screenshot" "No window found under cursor"
        fi
        ;;
    
    "Area (edit)")    
        grimblast edit area ;;
    
    "Screen (delay)") 
        sleep 3 && grimblast copy output && notify-send "Screenshot" "Fullscreen copied to clipboard" ;;
    
    "Screen (edit)")  
        grimblast edit output ;;
esac
