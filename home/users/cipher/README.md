# User: cipher

Personal Home Manager profile for user `cipher` (`/home/cipher`).

- Imports the NVF editor module and the Rofi module from
  `modules/home/`, plus the raw Hyprland/Waybar configs via
  `xdg.configFile`.
- User-specific settings: foot colors, git identity (`jmbealer`),
  sops (age key at `~/.config/sops/age/keys.txt`), stylix targets,
  gtk/qt themes, dconf, mimeApps.
- Shell aliases include dotfile-edit shortcuts (`vdh`, `vdc`, `vdp`,
  `vdn`) and rebuild shortcuts (`onr`, `nr`, `nu`, `enr`).

Shared, user-agnostic settings will move to `home/common/` in Phase 4.
