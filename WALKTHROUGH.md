# Walkthrough: Hyprland Lua Migration & Noctalia Shell Integration

We have successfully migrated your Hyprland configuration to the new native **Lua** configuration format (`hyprland.lua`) and integrated the **Noctalia** (v5.2.1) desktop shell into your NixOS dotfiles.

---

## Changes Summary

### 1. Flake Inputs & System Caching
- **[`flake.nix`](file:///home/cipher/.dotfiles/flake.nix)**:
  - Added `noctalia = { url = "github:noctalia-dev/noctalia/cachix"; };`.
  - Added `inputs.noctalia.homeModules.default` to `cipher`'s home-manager imports.
  - Added `extraSpecialArgs = { inherit inputs; };` to `home-manager` so modules can access inputs cleanly.
- **[`hosts/common/default.nix`](file:///home/cipher/.dotfiles/hosts/common/default.nix)**:
  - Added the official Noctalia Cachix substituter (`https://noctalia.cachix.org`) and public key (`noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=`) to `nix.settings`.
  - Enabled `services.upower.enable = true;` for battery and power management integration.

### 2. Noctalia Desktop Module
- **[`modules/home/desktop/noctalia/default.nix`](file:///home/cipher/.dotfiles/modules/home/desktop/noctalia/default.nix)**:
  - Configured `programs.noctalia` with default top bar widgets (`launcher`, `workspaces`, `active_window`, `clock`, `media`, `sysmon`, `volume`, `brightness`, `network`, `bluetooth`, `battery`, `notifications`, `control-center`).
  - Seamlessly harmonized with **Stylix**'s automatic Noctalia theming (generating `stylix-palette.json` and matching your system colors, fonts, and wallpaper).
- **[`home/users/cipher/default.nix`](file:///home/cipher/.dotfiles/home/users/cipher/default.nix)**:
  - Imported the new Noctalia module into user profile.

### 3. Hyprland Native Lua Migration
All configuration files in `~/.config/hypr/` are now powered by the native Lua API supported by Hyprland 0.56.2:

| File | Purpose | Key Details |
|---|---|---|
| **[`hyprland.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/hyprland.lua)** | Main entry point | Loads modules modularly via `require()` |
| **[`env.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/env.lua)** | Environment variables | Uses `hl.env()` for Wayland, cursor, and toolkit flags |
| **[`monitors.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/monitors.lua)** | Monitor settings | Configures `eDP-1` 1080p 144Hz 10-bit depth via `hl.monitor()` |
| **[`autostart.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/autostart.lua)** | Startup hook | `hl.on("hyprland.start", ...)` launches `noctalia`, scratchpad, clipboard, awww, wlsunset |
| **[`input.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/input.lua)** | Input & devices | `hl.config({ input = ... })`, touchpad natural scroll, 3-finger gestures, and `epic-mouse-v1` |
| **[`appearance.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/appearance.lua)** | Styling & layout | Layout (`scrolling`), borders, shadows, curves, and animations |
| **[`workspaces.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/workspaces.lua)** | Persistent workspaces | Lua `for` loop creating persistent workspaces 1–10 for `eDP-1` |
| **[`windowrules.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/windowrules.lua)** | Rules & layer effects | `hl.window_rule` for dialogs and `hl.layer_rule` for Noctalia blur/noanim |
| **[`keybindings.lua`](file:///home/cipher/.dotfiles/modules/home/desktop/hyprland/configs/keybindings.lua)** | Keybindings & submaps | Binds for Noctalia launcher, control center, settings, OSD, and Vim navigation |

- Previous `.conf` files preserved as `.conf.bak`.
- Updated `vch` alias in [`home/common/shell.nix`](file:///home/cipher/.dotfiles/home/common/shell.nix) to edit `hyprland.lua`.

---

## Verification Results

### 1. Lua Syntax Verification
Validated with `luac -p`:
```bash
$ luac -p modules/home/desktop/hyprland/configs/*.lua
# Exited 0 with no errors
```

### 2. Nix Flake Evaluation
```bash
$ nix eval .#nixosConfigurations.serval.config.system.build.toplevel.drvPath
"/nix/store/qdl3b6nni2mjqr642zb4v0ldjpr7yv8c-nixos-system-serval-26.11.20260910.8ce4ef6.drv"
```

### 3. Dry-Run Build Verification
```bash
$ nh os build /home/cipher/.dotfiles#serval --dry
# Exited 0
# Added:
#   [A.] noctalia 5.2.1
#   [A.] noctalia-config.toml
#   [A.] stylix-palette.json
```

---

## Applying the Changes

To activate your new setup, run:
```bash
nh os switch /home/cipher/.dotfiles#serval
```
or use your shell alias:
```bash
nr
```

### Live Test Checklist
- **Top Bar**: Noctalia bar will appear with persistent workspaces 1–10, active window title, clock, volume, battery, and tray.
- **`Super + Space` or `Super + D`**: Toggles the Noctalia application launcher.
- **`Super + S`**: Toggles the Noctalia Control Center.
- **`Super + ,`**: Opens Noctalia's live graphical settings window.
- **`Alt + Tab`**: Activates the Noctalia window switcher.
- **Volume & Brightness Keys**: Displays Noctalia's native on-screen display (OSD) feedback.
- **`Super + Alt + R`**: Executes `hyprctl reload` to hot-reload `hyprland.lua`.

---

# Walkthrough: Bashrc Error Resolution & NixOS Alias Suite

All shell startup errors have been resolved, and shell aliases have been revamped with an organized NixOS workflow suite in [`home/common/shell.nix`](file:///home/cipher/.dotfiles/home/common/shell.nix).

A backup of your previous shell configuration was saved to [`home/common/shell.nix.bak`](file:///home/cipher/.dotfiles/home/common/shell.nix.bak).

---

## 1. Resolved Issues

1. **`sed: unterminated 's' command`**:
   - Fixed missing trailing delimiter slash in Carapace completion initialization (`sed 's/read -r -d/builtin read -r -d/'`).
2. **`ble-*: command not found` (x5)**:
   - Moved `ble.sh` settings into native `~/.blerc` via `home.file.".blerc".text`.
   - Now ble.sh configurations only execute when `ble.sh` attaches to an interactive shell session, eliminating startup errors in scripts, `-c` commands, and subshells.
3. **Non-Interactive Shell Pollution**:
   - Moved `fastfetch`, Vi mode, and Carapace hooks out of `bashrcExtra` into `initExtra`. Non-interactive sessions (e.g., `scp`, `rsync`, automated tooling) now execute cleanly with zero unwanted stdout.
4. **`PROMPT_COMMAND` Preservation**:
   - Changed scalar assignment to safe prepend/append: `PROMPT_COMMAND="history -a; ''${PROMPT_COMMAND:-}"`, preventing conflicts with Starship.
5. **Path Portability**:
   - Replaced hardcoded `/home/cipher/` paths with dynamic `${config.home.homeDirectory}` across all navigation and config shortcuts.

---

## 2. NixOS & Shell Alias Cheat Sheet

### NixOS System & Home Manager (`nh` & `nix`)

| Command | Alias | Description |
| :--- | :--- | :--- |
| `nh os switch` | `nos` / `nr` | Rebuild and switch NixOS system generation |
| `nh os test` | `not` | Test system rebuild without creating a boot entry |
| `nh os boot` | `nob` | Build system and add to bootloader without switching immediately |
| `nh os switch --dry` | `nosd` | Dry-run system build (inspect package diffs) |
| `nh home switch` | `nhs` / `nu` | Rebuild and switch Home Manager generation |
| `nh home switch --dry` | `nhsd` | Dry-run Home Manager build |
| `nix flake update --flake ~/.dotfiles` | `nfu` | Update all flake inputs |
| `nh os switch --update` | `nuo` | Update flake inputs and switch system in one shot |
| `nh home switch --update` | `nhu` | Update flake inputs and switch Home Manager in one shot |
| `nh search <query>` | `ns` | Fast, colorful search across Nixpkgs |
| `nix search nixpkgs <query>` | `nsp` | Search official Nixpkgs flake |
| `manix <query>` | `nso` | Search NixOS and Home Manager options |
| `nix shell nixpkgs#<pkg>` | `nsh` | Launch temporary shell with package (e.g. `nsh jq`) |
| `nix run nixpkgs#<pkg>` | `nrn` | Run package once without installing (e.g. `nrn cowsay`) |
| `nh clean all` | `ncg` | Garbage collect old system & user generations |
| `nh clean all --dry` | `ncgd` | Dry-run garbage collection |
| `nixos-rebuild list-generations` | `ngen` | List system generations |
| `home-manager generations` | `nhgen` | List user generations |

### Dotfile & Config Navigation

| Target File / Directory | Editor Alias | Yazi / Cd Shortcut |
| :--- | :--- | :--- |
| `~/.dotfiles/flake.nix` | `vdf` | `cdd` / `tfd` / `ftd` |
| `~/.dotfiles/home/common/shell.nix` | `vds` | |
| `~/.dotfiles/home/users/cipher/default.nix` | `vdh` | |
| `~/.dotfiles/hosts/serval/default.nix` | `vdc` | |
| `~/.dotfiles/hosts/serval/packages.nix` | `vdp` | |
| `~/.dotfiles/modules/home/editors/nvf.nix` | `vdn` | |
| `~/.config/hypr/hyprland.lua` | `vch` | `cc` / `tfc` / `ftc` |
| `~/.config/noctalia/config.toml` | `vcn` | |
| `~/Documents/my-knowledge-base/` | | `ck` / `ftk` |
| `~/gdrive` | | `cg2` / `ftg2` |
| `/run/media/cipher/Elements-5TB/gdrive/` | | `cg` / `ftg` |

### Keyboard Backlight Utility

- `kb-red`: Set backlight to red at 50% brightness
- `kb-blue`: Set backlight to blue at 50% brightness
- `kb-off`: Turn backlight off
- Custom function `kb-color <HEX> <BRIGHTNESS>`: e.g. `kb-color 00FF00 80%`

---

## 3. Verification Summary

- **Non-interactive execution** (`bash -c 'echo SUCCESS'`): Verified 0 stderr, 0 extra output.
- **Interactive startup** (`bash -i -c 'exit'`): Verified 0 `ble-*` errors, 0 `sed` errors, clean fastfetch banner.
- **Alias registration**: Verified `nos`, `nfu`, `ns`, `nsh`, `vcn`, `vdf`, and `kb-red` resolve properly.
- **Dry-run build**: Verified `nh os test --dry` succeeded with exit code 0 (`ADDED: hm_.blerc`).

