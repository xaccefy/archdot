----------------
-- General window decoration
----------------
hl.config({
    decoration = {
        rounding = 13,
        blur = {
            enabled = false,
            size = 8,
            passes = 4,
            new_optimizations = true,
            ignore_opacity = false,
            xray = false,
        },
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1.0,
    },
    layerrule = {
    },
})

-- slurp's overlay (namespace "selection") must vanish instantly, not slide out.
-- grimblast tries to set this itself at runtime, but `hyprctl keyword layerrule`
-- is rejected by 0.55+'s non-legacy parser, so grim fires mid-animation and bakes
-- slurp's translucent background into the top of every area screenshot.
hl.layer_rule({ match = { namespace = "^selection$" }, no_anim = true })

----------------
-- Group (tabbed containers) settings
----------------
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
