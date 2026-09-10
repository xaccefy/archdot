hl.config({
    general = {
        gaps_in = 5,
        gaps_out = { top = 14, right = 14, bottom = 14, left = 14 },
        border_size = 2,
        col = {
            active_border = "rgba(ffffffff)",
            inactive_border = "rgba(6d6f82cc)",
        },
        layout = "dwindle",
    },
})

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })

hl.window_rule({ match = { fullscreen = 1 }, idle_inhibit = "fullscreen" })

hl.window_rule({
    match = { class = "^(mpv|vlc|imv|zoom|com.obsproject.Studio|org.kde.kdenlive)$" },
    opacity = "1 1",
})

hl.window_rule({
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    size = { 600, 338 },
    keep_aspect_ratio = true,
    border_size = 0,
    move = { "(monitor_w-window_w-40)", "(monitor_h*0.04)" },
})

hl.window_rule({
    match = { class = "^(WebCord|discord)$", title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
})

hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Save File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Choose File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Select Folder)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Confirm to replace files)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Authentication Required)(.*)$" }, float = true })

hl.window_rule({
    match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal)$" },
    float = true,
    center = 1,
    size = { 1040, 720 },
})

hl.window_rule({
    match = { class = "^(pavucontrol)$" },
    float = true,
    center = 1,
    size = { 900, 560 },
})

hl.window_rule({
    match = { class = "^(nm-connection-editor)$" },
    float = true,
    center = 1,
    size = { 960, 680 },
})

hl.window_rule({
    match = { class = "^(blueman-manager)$" },
    float = true,
    center = 1,
    size = { 980, 700 },
})

-- Blur only on MonoCode: disable blur everywhere else, make monocode translucent
hl.window_rule({
    match = { class = "negative:^(monocode|com.monocode.desktop|MonoCode|Monocode)$" },
    no_blur = true,
})

hl.window_rule({
    match = { class = "^(monocode|com.monocode.desktop|MonoCode|Monocode)$" },
    opacity = "0.7 0.7",
})
