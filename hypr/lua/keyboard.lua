hl.config({
    input = {
        kb_layout = "us,mn",
        kb_variant = "",
        kb_options = "grp:alts_toggle",
        kb_model = "",
        numlock_by_default = true,
        repeat_rate = 40,
        repeat_delay = 250,
        mouse_refocus = false,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
        sensitivity = 0,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
