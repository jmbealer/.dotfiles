# Common User Baseline

Shared Home Manager settings for any user on any machine. Populated
during the restructure (Phase 4) by extracting the user-agnostic
parts of `home/users/cipher/default.nix`.

## Planned contents

- `default.nix`
  - `home.packages`, `home.shellAliases`, `news.display`
  - `programs`: git (defaults), yazi, fzf, zoxide, nix-index,
    carapace, starship, dircolors, eza, delta, vivid, foot, floorp
  - `xdg.mimeApps`, `qt`, `gtk`, `dconf`
- `shell.nix`
  - `programs.bash` (history, shellOptions, sessionVariables,
    bashrcExtra, aliases)
  - `programs.readline` (variables, bindings)
