#!/usr/bin/env bash
# Arch update check + launcher for `paru -Syu`.
# `checkupdates` syncs a temp DB (fakeroot pacman -Sy) which can hang on slow
# mirrors — wrap in `timeout 10` to keep waybar's exec from blocking at start.
#
# Exit codes: 0 = updates available, 2 = up to date, 1 = sync failed
# (timeout gives 124). Only 1/124 should surface as an error state.
out=""
rc=0
if command -v timeout >/dev/null 2>&1; then
  out=$(timeout 10 checkupdates 2>/dev/null); rc=$?
  if [[ $rc -eq 124 || $rc -eq 1 ]]; then
    echo '{"text":"󰏗 ?","class":"error","tooltip":"Update check failed — click to retry"}'
    exit 0
  fi
else
  out=$(checkupdates 2>/dev/null) || true
fi

if [[ -z "$out" ]]; then
  echo '{"text":"","tooltip":"System up to date"}'
else
  n=$(wc -l <<< "$out")
  n=${n//[[:space:]]/}
  echo "{\"text\":\"󰏗 $n\",\"class\":\"pending\",\"tooltip\":\"$n updates — click to update\"}"
fi
