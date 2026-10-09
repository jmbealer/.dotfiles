# Modules

Reusable configuration blocks shared across hosts and users. Split by scope:

- `nixos/` — system-level modules (services, desktop compositors, theming).
  Applied to `nixosConfigurations` or imported by a host's `default.nix`.
- `home/` — user-level Home Manager modules (editors, desktop tools, shell).
  Imported by a user profile in `home/users/<name>/default.nix`.

## Writing a module

A module uses the standard `{ config, lib, pkgs, ... }:` signature. Feature
toggles use `lib.mkEnableOption`:

```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.myFeature;
in {
  options.myFeature.enable = lib.mkEnableOption "myFeature";
  config = lib.mkIf cfg.enable {
    # ...
  };
}
```

## Raw config files

Programs without good Home Manager options keep their native config files next
to their module (e.g. `home/desktop/hyprland/configs/`), symlinked into
`~/.config/` via `xdg.configFile`. Waybar scripts reference
`~/.config/waybar/scripts/`, so the whole directory (including `scripts/`)
must stay under `waybar/`.
