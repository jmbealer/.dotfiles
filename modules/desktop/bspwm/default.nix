{ config, lib, pkgs, protocol, ... }:

{
  config = lib.mkIf ( protocol == "X" ) {
    programs.dconf.enable = true;

    services = {
      xserver = {
        enable = true;

        layout = "us";
        libinput.enable = true;

        displayManager = {
          lightdm = {
            enable = true;
            background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
            greeters = {
              gtk = {
                theme = {
                  name = "gruvbox-dark";
                  package = pkgs.gruvbox-dark-gtk;
                };
                cursorTheme = {
                  name = "Numix-Cursor-Light";
                  package = pkgs.numix-cursor-theme;
                  size = 16;
                };
              };
            };
          };
          defaultSession = "none+bspwm";
        };
        windowManager = {
          bspwm = {
            enable = true;
          };
        };
        videoDrivers = [
          # "amdgpu"
          "nvidia"
        ];

        # displayManager.SessionCommands = '' '';

        serverFlagsSection = ''
          Option "BlankTime" "0"
          Option "StandbyTime" "0"
          Option "SuspendTime" "0"
          Option "OffTime" "0"
        '';
        # resolutions = [];
      };
    };
    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
      xclip
      xorg.xev
      xorg.xkill
      xorg.xrandr
      xterm
      # alacritty
      # sxhkd
    ];
  };

}
