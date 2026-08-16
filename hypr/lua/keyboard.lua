----------------
-- Keyboard / input
----------------
hl.config({
    input = {
        -- "us" must stay first: Hyprland resolves keybindings against the first
        -- layout, not the active one, so SUPER + <letter> binds would die under
        -- a Mongolian-first order.
        kb_layout = "us,mn",
        kb_variant = "",
        -- Alt+Shift collides with app shortcuts (JetBrains, browsers). Both Alts
        -- together is unused by applications and cannot misfire while typing.
        kb_options = "grp:alts_toggle",
        kb_model = "",
        numlock_by_default = true,
        -- Stock defaults are 25/600, which feels sluggish for held keys.
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

-- 3-finger horizontal swipe switches workspaces (Omarchy port).
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
