----------------
-- Misc settings
----------------
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        -- Let the compositor itself wake the panel on input.
        -- On NVIDIA, hypridle's on-resume never fires (monitor seen as
        -- disconnected after `dpms off`), leaving the lock screen frozen.
        key_press_enables_dpms = true,
        mouse_move_enables_dpms = true,
    },

    debug = {
        disable_logs = true,
        -- NVIDIA: VFR drops the frame rate to 0 on idle and the compositor
        -- hangs on wake (frozen clock, dead input). Force constant rendering.
        -- This alone is the wake fix; damage_tracking is not needed for it.
        vfr = false,
        -- damage_tracking = 0 (full redraw every frame) was set alongside vfr as a
        -- second NVIDIA workaround. It is documented as debug-only and, combined with
        -- vfr = false, meant every frame redrew the whole screen at 120 Hz forever --
        -- a permanent thermal cost on a chassis that is already cooling-bound.
        -- 2 is the default (full damage tracking). If the post-DPMS stall returns,
        -- try damage_tracking = 1 before going back to 0.
        damage_tracking = 2,
    },
})
