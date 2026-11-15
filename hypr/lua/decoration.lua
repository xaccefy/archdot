hl.config({
    decoration = {
        rounding = 8,
        blur = {
            enabled = false,
            size = 6,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
        },
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
    },
})

hl.layer_rule({ match = { namespace = "^selection$" }, no_anim = true })

-- (waybar blur rule removed: decoration.blur is disabled globally, so the rule
--  never did anything -- and the bar is solid anyway.)

hl.config({
    group = {
        groupbar = {
            enabled = false,
        },
        insert_after_current = true,
    },
})
