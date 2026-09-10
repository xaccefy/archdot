hl.config({
    decoration = {
        rounding = 12,
        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
        },
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
    },
    layerrule = {
    },
})

hl.layer_rule({ match = { namespace = "^selection$" }, no_anim = true })

hl.config({
    group = {
        groupbar = {
            enabled = false,
        },
        col = {
            border_active = "rgba(120, 169, 255, 0.75)",
            border_inactive = "rgba(69, 71, 90, 0.8)",
            border_locked_active = "rgba(120, 169, 255, 0.75)",
            border_locked_inactive = "rgba(69, 71, 90, 0.8)",
        },
        insert_after_current = true,
    },
})
