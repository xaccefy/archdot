#!/usr/bin/env bash
# Notification (dunst) pause indicator + toggle.
status() {
  if [[ "$(dunstctl is-paused)" == "true" ]]; then
    echo '{"text":"󰂛","tooltip":"Notifications: paused — click to resume"}'
  else
    echo '{"text":"󰂚","tooltip":"Notifications: on — click to pause"}'
  fi
}

toggle() {
  dunstctl set-paused toggle
  kill -RTMIN+10 "$(pgrep -x waybar)" 2>/dev/null
}

case "${1:-status}" in
  status) status ;;
  toggle) toggle ;;
esac
