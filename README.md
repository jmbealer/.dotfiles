# NixOS Dotfiles

Declarative NixOS + Home Manager configuration, managed as a flake.

## Directory Structure

```text
.
├── flake.nix                  # Flake inputs, outputs, and entrypoint
├── flake.lock                 # Pinned input versions
├── .sops.yaml                 # SOPS encryption rules
├── hosts/                     # Machine-specific configurations
│   ├── common/                # Shared baseline across all machines
│   │   ├── default.nix        # (planned) nix settings, locale, audio, sysctl
│   │   └── users.nix          # (planned) user definitions + Home Manager wiring
│   └── serval/                # System76 Serval WS laptop (hostname: serval)
│       ├── default.nix        # System config (boot, kernel, GPU, services, theming)
│       ├── hardware.nix       # Generated hardware config (nixos-generate-config)
│       └── packages.nix       # System-wide packages
├── modules/                   # Custom reusable NixOS / Home Manager modules
│   ├── nixos/                 # System-level (desktop/hyprland, services/keyd, ...)
│   └── home/                  # User-level (editors/nvf, desktop/hyprland, ...)
├── home/                      # User environments via Home Manager
│   ├── common/                # Shared CLI tools, git, shell aliases
│   └── users/
│       └── cipher/            # User profile for 'cipher'
│           └── default.nix
├── secrets/                   # SOPS-encrypted secrets
│   └── secrets.yaml
└── deprecated/                # Retired configs/backups kept for review
```

## Usage

```bash
# Rebuild system (run from this directory)
sudo nixos-rebuild switch --flake .#serval
# or, with nh
nh os switch

# Rebuild Home Manager
home-manager switch --flake .

# Update flake inputs
nix flake update

# Validate evaluation without applying
nix flake check
```

## Secrets

Secrets are managed with SOPS + age. The age private key is expected at
`~/.config/sops/age/keys.txt`. Only edit `secrets/secrets.yaml` through `sops`.

## Conventions

- **Hosts** live in `hosts/<hostname>/`; each has a `default.nix` imported by
  `flake.nix` as `nixosConfigurations.<hostname>`. See `hosts/README.md`.
- **Modules** are reusable, ideally toggleable blocks in `modules/`. See
  `modules/README.md`.
- **User profiles** live in `home/users/<name>/` and are wired into
  `home-manager.users.<name>` in `flake.nix`. See `home/README.md`.
- **Raw config files** (Hyprland `.conf`, Waybar `config.jsonc`, etc.) stay
  next to their module and are symlinked into `~/.config/` via `xdg.configFile`.
- **Deprecated** files are moved to `deprecated/` with an explanation instead of
  being deleted, until manually reviewed.
