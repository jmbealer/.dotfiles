# Deprecated Dotfiles

This directory contains host and user configurations, backups, and
stray files that have been superseded by the modernized dotfiles
layout. They are retained here for historical reference until a manual
review confirms they can be safely deleted.

## Contents

- `hosts/myhost/` — Old configuration for a machine named `myhost`.
  No longer referenced by `flake.nix`.
- `homes/0xjb/` — Old Home Manager configuration for user `0xjb`.
  No longer referenced by `flake.nix`.
- `backups/` — Stale `*.bak` / `*-new` / `*-old` snapshots of config
  files (flake, hardware configs, waybar css/jsonc) kept during the
  restructure.
- `misc/` — Stray root-level files:
  - `config.rasi` — manual Rofi theme, superseded by `programs.rofi`
    options in `modules/home/desktop/rofi.nix`
  - `configuration.nix-new` — old configuration draft
  - `test.conf` — unknown test file
  - `REBUILD_INSTRUCTIONS.md` — rebuild notes referencing the old
    user/host (`0xjb` / `myhost`)
  - `waybar-minimal-test/` — downloaded example Waybar project, not
    used by the active config
  - `disks.nix` — abandoned Disko partition layout. Rejected because
    the multi-device Btrfs (spanning both NVMe drives) cannot be
    expressed in Disko, and this is not a fresh install. Storage
    stays in `hosts/serval/hardware.nix` instead.

## Why these were deprecated

- **`hosts/myhost/`**: Legacy/duplicate host configuration. The active
  host is `hosts/serval/` (hostname: `serval`).
- **`homes/0xjb/`**: Legacy user profile for a previous username
  (`0xjb`). The active user profile is `home/users/cipher/`.
- **Backups/misc**: Redundant with the current, modular files.

## Review & cleanup

Once you have verified that nothing in these directories is needed:

```bash
rm -rf deprecated/
```

No other files reference these paths, so removing this directory will
not affect your current system configuration.
