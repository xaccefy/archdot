----------------
-- General window behavior and rules
----------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = { top = 14, right = 14, bottom = 14, left = 14 },
        -- Borderless by choice. This used to read `false`, which Hyprland
        -- coerces to 0 anyway -- the explicit 0 just says so out loud. The
        -- colours below are kept because scripts/wallpaper-accent.sh still
        -- writes an active_border; raise this to 2 to make either visible.
        border_size = 0,
        col = {
            active_border = "rgba(220, 220, 220, 0.75)",
            inactive_border = "rgba(109, 111, 130, 0.8)",
        },
        layout = "dwindle",
    },
})

-- Ported from Omarchy default/hypr/windows.lua:
-- stop apps' fake-maximize jank.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Fix some dragging issues with XWayland (Omarchy port).
hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })

hl.window_rule({ match = { fullscreen = 1 }, idle_inhibit = "fullscreen" })

----------------
-- Media: opt out of the global inactive_opacity
----------------
-- decoration.lua dims every unfocused window to 0.9. That is fine for text but
-- wrong for video, which should stay at full opacity whether focused or not.
hl.window_rule({
    match = { class = "^(mpv|vlc|imv|zoom|com.obsproject.Studio|org.kde.kdenlive)$" },
    opacity = "1 1",
})

----------------
-- Picture-in-picture
----------------
-- Sized and positioned by formula rather than fixed pixels: the old rule paired
-- `size 480 270` with `move 100%-500 40`, leaving a stray 20px gap, and both
-- numbers assumed a single monitor. monitor_w/monitor_h resolve per output, so
-- this lands correctly on eDP-1 and on HDMI-A-1.
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

----------------
-- Dialogs
----------------
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Save File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Choose File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Select Folder)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Confirm to replace files)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Authentication Required)(.*)$" }, float = true })

----------------
-- Floating utilities
----------------
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
