#!/usr/bin/env bash
# Screen recording indicator + toggle (wf-recorder + slurp).
OUT_DIR="$HOME/Videos"

status() {
  if pgrep -x wf-recorder >/dev/null; then
    echo '{"text":"󰑋","class":"active","tooltip":"Recording — click to stop"}'
  else
    echo '{"text":"","tooltip":"Click to start screen recording"}'
  fi
}

start() {
  mkdir -p "$OUT_DIR"
  local file="$OUT_DIR/rec-$(date +%F-%H%M%S).mp4"
  local geom
  geom=$(slurp -d 2>/dev/null)
  if [[ -n "$geom" ]]; then
    wf-recorder -g "$geom" -f "$file" >/dev/null 2>&1 &
  else
    wf-recorder -a -f "$file" >/dev/null 2>&1 &
  fi
}

stop() {
  pkill -x wf-recorder
}

case "${1:-status}" in
  status) status ;;
  toggle)
    if pgrep -x wf-recorder >/dev/null; then stop; else start; fi
    kill -RTMIN+8 "$(pgrep -x waybar)" 2>/dev/null
    ;;
esac
