----------------
-- Custom
----------------

-- Border accent derived from the current wallpaper by
-- scripts/wallpaper-accent.sh. Loaded last so it overrides the static fallback
-- in lua/window.lua, and wrapped in pcall so a missing or half-written cache
-- file can never take the whole config down.
pcall(dofile, (os.getenv("HOME") or "") .. "/.cache/hypr-accent.lua")

-- Add additional Hyprland Lua configuration here.
