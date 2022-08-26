{ pkgs, ...}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc.bak
    '';
    profileExtra = ''
      export XDG_DATA_DIRS=\"$HOME/.nix-profile/share:$XDG_DATA_DIRS\"
      . ~/.bash_profile.bak
    '';
  };
}
