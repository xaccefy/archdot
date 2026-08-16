----------------
-- Animation
----------------
-- Mirrors Omarchy's default/hypr/looknfeel.lua animation set exactly
-- (curves, speeds, styles, enabled/disabled leaves).

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.2, 0.0 }, { 0.1, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

-- Spawn/close/fade: original tuning was 150ms plain settle, no scale — popin
-- shimmered on the supersampled panel, and the Omarchy easeOutQuint tail felt
-- draggy. Keeping the plain/no-scale part, shortened to 80ms on 2026-08-15:
-- once the terminal spawn itself dropped from 177ms to 76ms (D-Bus launch, see
-- keybinding.lua), the animation was the larger half of the perceived delay.
-- Rest of the file mirrors Omarchy.
hl.animation({ leaf = "windows", enabled = true, speed = 0.8, bezier = "default" })
-- windowsIn/windowsOut intentionally NOT set: open/close fall back to
-- `windows`, matching the pre-Omarchy behavior exactly.
-- Reflow of existing windows when a new one opens. Biggest single win.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch", enabled = false })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
