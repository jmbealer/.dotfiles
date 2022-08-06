{ pkgs, ...}: {
  programs.bash = {
    enable = true;
    # bashrcExtra = '''';
    profileExtra = "export XDG_DATA_DIRS=\"$HOME/.nix-profile/share:$XDG_DATA_DIRS\"";
  };
}
