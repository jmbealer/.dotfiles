# NixOS Modules

System-level reusable modules. Applied to `nixosConfigurations` in
`flake.nix` or imported by a host's `default.nix`.

## Planned / active modules

- `desktop/hyprland.nix` — Hyprland compositor, XWayland, xdg portal
- `desktop/stylix.nix` — system-wide theming baseline
- `services/keyd.nix` — keyboard remapping daemon (systemd keyd)
- `services/nextdns.nix` — NextDNS DNS resolver

Extracted from `hosts/serval/default.nix` during Phase 4 so they can be
reused by other hosts.
