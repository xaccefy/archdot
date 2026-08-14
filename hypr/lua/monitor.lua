----------------
-- Monitors
----------------
-- eDP-1's EDID advertises only 1920x1080 (`cat /sys/class/drm/card*-eDP-1/modes`), so this
-- is a forced custom mode: Hyprland renders 2560x1440 and the panel scaler downsamples to
-- 1080p. That is deliberate -- the 0.75x downsample is real supersampling AA, and it reads
-- noticeably smoother than native 1080p.
--
-- Do NOT "fix" this to 1920x1080 + scale 0.8. Native mode with a fractional scale below 1
-- looks chunkier, not sharper: GTK and XWayland clients round to integer scale 1 and then
-- get non-integer downscaled, which aliases. Tried 2026-08-12, reverted immediately.
--
-- The frame cost this used to carry came from debug.damage_tracking = 0 in misc.lua, which
-- forced a full-screen redraw of all 3.7 Mpix every frame at 120 Hz. With damage tracking
-- back at its default only changed regions redraw, so the high framebuffer is cheap at idle.
hl.monitor({
    output = "eDP-1",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",
    position = "auto",
    scale = 1,
    mirror = "eDP-1",
})
