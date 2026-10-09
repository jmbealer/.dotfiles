# Desktop Modules (Home Manager)

- `hyprland/` — Hyprland config files in `configs/`, symlinked to
  `~/.config/hypr/` (`hyprland.conf`, `keybindings.conf`,
  `windowrules.conf`, `monitors.conf`, `input.conf`, `autostart.conf`,
  `appearance.conf`, `env.conf`, `programs.conf`, `workspaces.conf`,
  `hypridle.conf`, `hyprlock.conf`)
- `waybar/` — `config.jsonc`, `style.css`, and `scripts/`, symlinked
  to `~/.config/waybar/`. Scripts are invoked from `config.jsonc` via
  `~/.config/waybar/scripts/`, so the directory layout must be kept.
- `rofi.nix` — Rofi launcher configuration (`programs.rofi`)
