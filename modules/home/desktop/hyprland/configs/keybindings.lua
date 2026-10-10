---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local subMod  = "ALT"
local ipc     = "noctalia msg "

-- Application Bindings
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + " .. subMod .. " + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("floorp"))

-- Noctalia Shell Integration
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + D",     hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + S",     hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind("ALT + Tab",           hl.dsp.exec_cmd(ipc .. "window-switcher hold"))

-- System & Utilities
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + " .. subMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + " .. subMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Screenshot bindings
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

-- Vim-style focus movement
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Layout management
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl keyword general:layout scrolling"))
hl.bind(mainMod .. " + " .. subMod .. " + M", hl.dsp.exec_cmd("hyprctl --batch 'keyword general:layout master ; keyword master:orientation center'"))
hl.bind(mainMod .. " + " .. subMod .. " + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + " .. subMod .. " + L", hl.dsp.layout("swapcol r"))

-- Workspaces (1 - 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Relative workspace navigation
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + Tab",          hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1" }))

-- Window State
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(1))
hl.bind(mainMod .. " + " .. subMod .. " + F", hl.dsp.window.fullscreen(0))
hl.bind(mainMod .. " + " .. subMod .. " + P", hl.dsp.window.pin())

-- Special workspaces (Scratchpad & Magic)
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + " .. subMod .. " + Return", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + " .. subMod .. " + Return", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.workspace.toggle_special("magic"))

-- Media & Brightness (using Noctalia OSD)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -d *kbd_backlight* set 5%+"), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown",hl.dsp.exec_cmd("brightnessctl -d *kbd_backlight* set 5%-"), { locked = true, repeating = true })

-- Player controls
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Resize Submap (Vim-style)
-- hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
-- hl.define_submap("resize", "Escape", function()
--     hl.bind("", "L", hl.dsp.window.resize({ x = 10, y = 0 }), { repeating = true })
--     hl.bind("", "H", hl.dsp.window.resize({ x = -10, y = 0 }), { repeating = true })
--     hl.bind("", "K", hl.dsp.window.resize({ x = 0, y = -10 }), { repeating = true })
--     hl.bind("", "J", hl.dsp.window.resize({ x = 0, y = 10 }), { repeating = true })
-- end)
