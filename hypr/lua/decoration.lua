----------------
-- General window decoration
----------------
hl.config({
    decoration = {
        rounding = 6,
        blur = {
            enabled = false,
            size = 8,
            passes = 4,
            new_optimizations = true,
            ignore_opacity = false,
            xray = false,
        },
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
    },
    layerrule = {
    },
})

----------------
-- Group (tabbed containers) settings
----------------
hl.config({
    group = {
        groupbar = {
            enabled = true,
            render_titles = true,
            height = 24,
            font_size = 16,
            gradients = true,
            col = {
                active = "0xcc3a3a3a",
                inactive = "0xcc000000",
                locked_active = "0xcc4a3030",
                locked_inactive = "0xcc000000",
            },
        },
        insert_after_current = true,
    },
})
