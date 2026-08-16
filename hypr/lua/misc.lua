----------------
-- Misc settings
----------------
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        -- Let the compositor itself wake the panel on input.
        -- Original note: on NVIDIA, hypridle's on-resume never fires (monitor
        -- seen as disconnected after `dpms off`), leaving the lock screen
        -- frozen. That may well have been true under the old hyprland.conf, but
        -- it cannot describe current behaviour: since the Lua migration all
        -- three dpms lines in hypridle.conf used the legacy
        -- `hyprctl dispatch dpms off` form, which errors out under the Lua
        -- parser and never ran at all. Fixed 2026-08-15. Keeping these two on
        -- regardless -- input-wakes-panel is worth having either way. Omarchy
        -- sets both in default/hypr/input.lua too.
        key_press_enables_dpms = true,
        mouse_move_enables_dpms = true,
    },

    debug = {
        disable_logs = true,
        -- Was false as an NVIDIA wake workaround: VFR drops the frame rate to 0
        -- on idle and the compositor hung on wake (frozen clock, dead input).
        -- Re-enabled 2026-08-15 because that reasoning does not apply here --
        -- Hyprland composites on card2 (i915), not the dGPU, and eDP-1 lives
        -- there too. With it false the compositor rendered 120 fps forever with
        -- nothing on screen changing, burning ~4.3% of a core at idle and
        -- feeding a chassis that throttled 149s in a 49min uptime.
        -- If the post-DPMS wake stall comes back, set this to false again.
        vfr = true,
        -- damage_tracking = 0 (full redraw every frame) was set alongside vfr as a
        -- second NVIDIA workaround. It is documented as debug-only and, combined with
        -- vfr = false, meant every frame redrew the whole screen at 120 Hz forever --
        -- a permanent thermal cost on a chassis that is already cooling-bound.
        -- 2 is the default (full damage tracking). If the post-DPMS stall returns,
        -- try damage_tracking = 1 before going back to 0.
        damage_tracking = 2,
    },
})
