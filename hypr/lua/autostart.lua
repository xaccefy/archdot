----------------
-- Autostart
----------------
hl.on("hyprland.start", function()
    -- Slow-app-launch fix (ported from Omarchy's default/hypr/autostart.lua):
    -- D-Bus-activated services (portals, Electron apps) inherit a nearly empty
    -- environment unless it is imported before anything starts.
    hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")

    hl.exec_cmd("~/.config/hypr/scripts/xdg.sh")
    -- The bar is the "session is ready" signal; start it right after env setup.
    hl.exec_cmd("~/.config/waybar/launch.sh")
    hl.exec_cmd("pgrep -f polkit-gnome-authentication-agent-1 >/dev/null || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-blue-Dark-compact'")
    hl.exec_cmd("pgrep -x hypridle >/dev/null || hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store &")
    hl.exec_cmd("pgrep -x awww-daemon >/dev/null || awww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/restore_wallpaper.sh")
    hl.exec_cmd("pgrep -x nm-applet >/dev/null || nm-applet")
    hl.exec_cmd("pgrep -x blueman-applet >/dev/null || blueman-applet")
    hl.exec_cmd("xrdb ~/.Xresources")
    hl.exec_cmd("pgrep -x dunst >/dev/null || dunst")
    hl.exec_cmd("pgrep -f 'gnome-keyring-daemon.*secrets' >/dev/null || gnome-keyring-daemon --start --components=secrets")
    -- The binary is `caffeine` but its process comm is `caffeine-ng`, so `pgrep -x caffeine`
    -- never matched and the guard was dead. -f matches the full command line instead.
    hl.exec_cmd("pgrep -f caffeine >/dev/null || caffeine")
    hl.exec_cmd("hyprctl setcursor Bibata-Original-Classic 25")
    -- Reapply the waybar CPU perf mode. power-profiles-daemon restores its own
    -- profile from state.ini across a reboot, but max_perf_pct is sysfs and
    -- always comes back at 100 -- so without this, "blend" would come up as
    -- performance fans with no cap (i.e. turbo) while the bar still said blend.
    hl.exec_cmd("~/.config/waybar/scripts/perf.sh restore")
end)
