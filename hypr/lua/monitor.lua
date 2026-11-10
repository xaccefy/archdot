hl.monitor({
    output = "eDP-1",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1,
})

-- DP-1 is the real external (USB-C path): mirror the laptop screen.
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@60",
    scale = 1,
    mirror = "eDP-1",
})

-- Phantom connector: nothing is actually attached (kernel cmdline forces it
-- on via video=HDMI-A-1:e). Mirror eDP-1 so it does the right thing if a real
-- HDMI display ever appears.
hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",
    scale = 1,
    mirror = "eDP-1",
})
