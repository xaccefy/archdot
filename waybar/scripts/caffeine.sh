#!/bin/bash

# caffeine.sh - Toggle caffeine mode (inhibits sleep)

# Function to check if caffeine is active by checking if the process is running
check_caffeine() {
    pgrep -x "caffeine" > /dev/null
    return $?
}

# Function to get caffeine status for Waybar
get_status() {
    if check_caffeine; then
        echo '{"text": " ☕ ", "tooltip": "Caffeine is ON"}'
    else
        echo '{"text": " ☕ ", "tooltip": "Caffeine is OFF"}'
    fi
}

# Function to toggle caffeine
toggle_caffeine() {
    if check_caffeine; then
        pkill -x "caffeine"
        # Optionally send notification
        notify-send "Caffeine" "Disabled" -u low -t 1000
    else
        caffeine &
        sleep 0.1
        # Optionally send notification
        notify-send "Caffeine" "Enabled" -u low -t 1000
    fi
}

case "$1" in
    "status")
        get_status
        ;;
    "toggle")
        toggle_caffeine
        ;;
    *)
        echo 'Usage: caffeine.sh {status|toggle}'
        exit 1
        ;;
esac
