hl.on("hyprland.start", function()
    -- Hyprland imports the session environment itself; xdg.sh handles the
    -- targeted D-Bus update needed by portals.
    hl.exec_cmd("~/.config/hypr/scripts/xdg.sh")
    -- waybar is started by waybar.service (systemd --user, graphical-session.target).
    -- Launching it here too raced: the loser spun in launch.sh's pgrep wait and
    -- would respawn waybar after an intentional kill.
    hl.exec_cmd("pidof polkit-gnome-authentication-agent-1 >/dev/null || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")
    hl.exec_cmd("pgrep -f 'wl-paste --[w]atch' >/dev/null || wl-paste --watch ~/.config/scripts/clipboard-watch.sh &")
    hl.exec_cmd("pgrep -x awww-daemon >/dev/null || awww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/restore_wallpaper.sh")
    hl.exec_cmd("pgrep -x nm-applet >/dev/null || nm-applet")
    hl.exec_cmd("pgrep -x blueman-applet >/dev/null || blueman-applet")
    hl.exec_cmd("xrdb ~/.Xresources")
    hl.exec_cmd("pkill -x dunst 2>/dev/null; pgrep -x mako >/dev/null || mako")
    hl.exec_cmd("pidof gnome-keyring-daemon >/dev/null || gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("~/.config/waybar/scripts/perf.sh restore")
end)
