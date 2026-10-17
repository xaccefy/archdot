hl.config({
    input = {
        kb_layout = "us,mn",
        -- Caps Lock switches layouts so Alt remains available for shortcuts.
        kb_options = "grp:alt_shift_toggle",
        numlock_by_default = true,
        repeat_rate = 40,

        repeat_delay = 250,
        mouse_refocus = false,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
