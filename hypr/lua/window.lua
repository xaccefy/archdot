----------------
-- General window behavior and rules
----------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = { top = 14, right = 14, bottom = 14, left = 14 },
        border_size = false,
        col = {
            active_border = "rgba(220, 220, 220, 0.75)",
            inactive_border = "rgba(109, 111, 130, 0.8)",
        },
        layout = "dwindle",
    },
})

local function window_rule(spec)
    hl.window_rule(spec)
end

window_rule({ match = { fullscreen = 1 }, idle_inhibit = "fullscreen" })

window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
window_rule({ match = { title = "^(Picture-in-Picture)$" }, pin = true })
window_rule({ match = { title = "^(Picture-in-Picture)$" }, size = "480 270" })
window_rule({ match = { title = "^(Picture-in-Picture)$" }, move = "100%-500 40" })

window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
window_rule({ match = { title = "^(Save File)(.*)$" }, float = true })
window_rule({ match = { title = "^(Choose File)(.*)$" }, float = true })
window_rule({ match = { title = "^(File Upload)(.*)$" }, float = true })
window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
window_rule({ match = { title = "^(Select Folder)(.*)$" }, float = true })
window_rule({ match = { title = "^(Authentication Required)(.*)$" }, float = true })
window_rule({ match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal)$" }, float = true })
window_rule({ match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal)$" }, center = 1 })
window_rule({ match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal)$" }, size = "1040 720" })
window_rule({ match = { class = "^(WebCord|discord)$", title = "^(Picture-in-Picture)$" }, float = true })
window_rule({ match = { class = "^(WebCord|discord)$", title = "^(Picture-in-Picture)$" }, pin = true })
window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
window_rule({ match = { class = "^(pavucontrol)$" }, size = "900 560" })
window_rule({ match = { class = "^(pavucontrol)$" }, center = 1 })
window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
window_rule({ match = { class = "^(nm-connection-editor)$" }, center = 1 })
window_rule({ match = { class = "^(nm-connection-editor)$" }, size = "960 680" })
window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
window_rule({ match = { class = "^(blueman-manager)$" }, center = 1 })
window_rule({ match = { class = "^(blueman-manager)$" }, size = "980 700" })
window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true })
window_rule({ match = { title = "^(Confirm to replace files)(.*)$" }, float = true })
