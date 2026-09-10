#!/usr/bin/env bash
# Notification (mako) do-not-disturb indicator + toggle.
status() {
  if makoctl mode 2>/dev/null | grep -q "do-not-disturb"; then
    echo '{"text":"󰂛","tooltip":"Notifications: paused — click to resume"}'
  else
    echo '{"text":"󰂚","tooltip":"Notifications: on — click to pause"}'
  fi
}

toggle() {
  makoctl mode -t do-not-disturb >/dev/null 2>&1
  kill -RTMIN+10 "$(pgrep -x waybar)" 2>/dev/null
}

case "${1:-status}" in
  status) status ;;
  toggle) toggle ;;
esac
