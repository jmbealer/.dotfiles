# Common Host Baseline

Shared NixOS settings applied to every machine. Populated during the restructure
(Phase 4) by extracting the machine-agnostic parts of `hosts/serval/default.nix`.

## Planned contents

- `default.nix`
  - `nix.settings` (flakes, auto-optimise-store, substitutes)
  - `nix.gc` / `programs.nh` (garbage collection policy)
  - `documentation` (man page caches)
  - `boot.kernel.sysctl` (TCP BBR, ptrace scope)
  - `powerManagement`, `services.pipewire`, `security.rtkit`
  - `time.timeZone`, `location.provider`, `networking` defaults
- `users.nix`
  - `users.users.cipher` (groups, packages)
  - Home Manager module wiring (`useGlobalPkgs`, `useUserPackages`, `backupFileExtension`)
