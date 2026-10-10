---------------------------------
---- WINDOW AND LAYER RULES -----
---------------------------------

-- Noctalia Settings Window
hl.window_rule({
    name   = "noctalia-settings",
    match  = { class = "dev.noctalia.Noctalia" },
    float  = true,
    center = true,
    size   = "1080 920",
})

-- Noctalia Layer Surfaces (Bar, Panels, OSD, Notifications)
hl.layer_rule({
    name         = "noctalia-layers",
    match        = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    no_anim      = true,
    blur         = true,
    ignore_alpha = 0.5,
    blur_popups  = true,
})

-- Rofi & Notifications layer rules
hl.layer_rule({ name = "rofi-blur", match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ name = "notifications-blur", match = { namespace = "notifications" }, blur = true })

-- Application Floating & Dialog Rules
hl.window_rule({
    name   = "float-calculator",
    match  = { class = "(org.gnome.Calculator|qalculate-gtk)" },
    float  = true,
    center = true,
    size   = "480 580",
})

hl.window_rule({
    name   = "float-pavucontrol",
    match  = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name  = "float-media",
    match = { class = "^(mpv|com.github.rafostar.Clapper)$" },
    float = true,
})

hl.window_rule({
    name   = "picture-in-picture",
    match  = { title = "^(Picture-in-Picture)$" },
    float  = true,
    pin    = true,
    move   = "72% 7%",
    size   = "30% 30%",
})

hl.window_rule({
    name   = "auth-dialog",
    match  = { title = "^(Authentication Required)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name   = "save-as-dialog",
    match  = { title = "^(Save As)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name   = "open-files-dialog",
    match  = { initial_title = "(Open Files)" },
    float  = true,
    center = true,
})

hl.window_rule({
    name   = "yad-dialog",
    match  = { class = "^(yad)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name   = "whatsapp-zapzap",
    match  = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
    center = true,
})

-- Prevent idle during fullscreen
hl.window_rule({
    name         = "fullscreen-idle-inhibit",
    match        = { fullscreen = true },
    idle_inhibit = "fullscreen",
})
