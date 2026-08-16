----------------
-- Environment
----------------
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GTK_THEME", "Graphite-blue-Dark-compact")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")
hl.env("GTK_CSD", "0")
-- Without QT_QPA_PLATFORM, Qt apps fall back to XWayland even though qt6ct and
-- kvantum are installed. "wayland;xcb" prefers native Wayland and keeps xcb as
-- the fallback for the few Qt apps that still need X11.
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Video decode on the Intel iGPU, deliberately. Hyprland composites on card2
-- (i915 -- eDP-1 lives there and no AQ_DRM_DEVICES override is set), so decoding
-- on Intel keeps frames on the same GPU that presents them: no PCIe copy, and
-- the dGPU stays parked. NVD_BACKEND used to be set here alongside this, but it
-- is read only by the *nvidia* VA-API driver and was therefore inert.
hl.env("LIBVA_DRIVER_NAME", "iHD")

-- Keep XWayland/GLX apps on the Intel iGPU by default so the RTX 3050 can
-- suspend. Use `prime-run <app>` when an app needs the discrete GPU.
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("MOZ_DBUS_REMOTE", "1")
hl.env("XCURSOR_THEME", "Bibata-Original-Classic")
hl.env("XCURSOR_SIZE", "25")
-- XCURSOR_SIZE only covers XCursor clients. Hyprland's own cursor reads
-- HYPRCURSOR_SIZE, so without this the compositor cursor is a different size
-- from the one apps draw.
hl.env("HYPRCURSOR_SIZE", "25")
