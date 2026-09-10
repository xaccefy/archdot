#!/usr/bin/env bash
# Idle (hypridle) indicator + toggle.
status() {
  if pgrep -x hypridle >/dev/null; then
    echo '{"text":"󰒲","tooltip":"Hypridle: running — click to stop"}'
  else
    echo '{"text":"󰅶","tooltip":"Hypridle: stopped — click to start"}'
  fi
}

toggle() {
  if pgrep -x hypridle >/dev/null; then
    pkill -x hypridle
  else
    nohup hypridle >/dev/null 2>&1 &
  fi
  kill -RTMIN+9 "$(pgrep -x waybar)" 2>/dev/null
}

case "${1:-status}" in
  status) status ;;
  toggle) toggle ;;
esac
