hl.config({
    dwindle = {
        preserve_split = true,
    },

    -- dwm "tile" layout: one master on the left, stack column on the right.
    -- new_on_top=false + new_on_active=none replicates the attachbottom
    -- patch: new windows always land at the bottom of the stack.
    master = {
        mfact = 0.55,
        orientation = "left",
        new_status = "slave",
        new_on_top = false,
        new_on_active = "none",
    },
})
