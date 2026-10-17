hl.monitor({
    output = "eDP-1",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1,
})

-- HDMI is intentionally configured as a mirror of the laptop panel.
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "auto",
    scale = 1,
})
