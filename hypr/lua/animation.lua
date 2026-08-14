----------------
-- Animation
----------------
hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("quick", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })  -- snappy settle
hl.curve("smooth", { type = "bezier", points = { { 0.2, 0.0 }, { 0.1, 1.0 } } })  -- soft ease

-- `speed` is in units of 100ms, so speed = 2 is a 200ms animation.
--
-- Ghostty itself takes ~0.70s from launch to a mapped window (measured off the Hyprland
-- event socket) and zsh adds 0.04s -- neither is the part that felt slow. The animation
-- time stacks on top of that and is the part actually worth cutting: opening a window used
-- to cost 200ms to draw it plus a 400ms windowsMove reflow of every sibling.
hl.animation({ leaf = "windows", enabled = true, speed = 1.5, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "default" })
-- 4 -> 2: this is the reflow of existing windows when a new one opens. Biggest single win.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "quick", style = "slide" })
-- general.border_size is 0, so both of these animate something with no pixels on screen.
-- borderangle at speed 8 was an 800ms animation of an invisible border.
hl.animation({ leaf = "border", enabled = false })
hl.animation({ leaf = "borderangle", enabled = false })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "quick", style = "slidefade 20%" })
