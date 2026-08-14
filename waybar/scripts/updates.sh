#!/usr/bin/env bash
# Arch update check (checkupdates) + launcher for paru -Syu.
n=$(checkupdates 2>/dev/null | wc -l)
if [[ "$n" -gt 0 ]]; then
  echo "{\"text\":\"󰏗 $n\",\"class\":\"pending\",\"tooltip\":\"$n updates — click to update\"}"
else
  echo '{"text":"","tooltip":"System up to date"}'
fi
