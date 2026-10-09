# Home

User environments managed by Home Manager.

- `common/` — baseline shared by **every** user on **every** machine:
  CLI tools, git defaults, shell aliases, readline/bash options.
- `users/<name>/` — per-user profile. Imports `common/` plus the
  modules that user needs, and holds user-specific settings (git
  identity, terminal colors, themes, mime apps).

The active profile is wired into `flake.nix` via
`home-manager.users.<name>`.

## Adding a user

1. Create `home/users/<name>/default.nix` importing `../../common/default.nix`
2. Add a `home-manager.users.<name>` entry in `flake.nix`
3. Add the system user in `hosts/common/users.nix`
