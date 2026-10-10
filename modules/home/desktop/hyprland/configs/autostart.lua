-------------------
---- AUTOSTART ----
-------------------

-- Startup processes when Hyprland launches
hl.on("hyprland.start", function()
    -- Sync environment
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Desktop Shell
    hl.exec_cmd("noctalia")

    -- Scratchpad terminal
    hl.exec_cmd("[workspace special:scratchpad silent] kitty --class scratchpad")

    -- Clipboard management
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Cloud & Browser
    hl.exec_cmd("rclone mount gdrive: ~/gdrive")
    hl.exec_cmd("floorp")

    -- Wallpaper daemon & night light
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("wlsunset -l 29.9 -L -95.2 -t 3700 -T 5500")

    -- Idle daemon & polkit authentication agent
    hl.exec_cmd("hypridle")
    hl.exec_cmd("sh -c '$(ls -d /nix/store/*polkit-gnome-0* | head -n 1)/libexec/polkit-gnome-authentication-agent-1'")

    -- Replaced by Noctalia (kept for reference):
    -- hl.exec_cmd("waybar")
    -- hl.exec_cmd("swaync")
    -- hl.exec_cmd("nm-applet --indicator")
end)
