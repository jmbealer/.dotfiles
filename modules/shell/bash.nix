{ config, options, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let cfg = config.modules.shell.bash;
in {
  options.modules.shell.bash = {
    enable = mkBoolOpt false;
  };

  config = cfg.enable {
    users.defaultUserShell = pkgs.bash;

    programs.bash = {
      enable = true;
    };

    user.packages = with pkgs; [
      bash
      # nix-zsh-completions
      bash-completion
      nix-bash-completions
      bat
      exa
      fasd
      fd
      fzf
      jq
      ripgrep
      tldr
    ];

    # env = {
      # ZDOTDIR   = "$XDG_CONFIG_HOME/zsh";
      # ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
      # ZGEN_DIR  = "$XDG_DATA_HOME/zgenom";
    # };
  };
}
