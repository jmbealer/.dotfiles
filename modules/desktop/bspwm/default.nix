#  Bspwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix *
{ config, lib, pkgs, protocol, ... }: {
  config = lib.mkIf ( protocol == "X" ) {
    programs.dconf.enable = true;

    services = {
      xserver = {
        enable = true;

        layout = "us";
        libinput.enable = true;
        dpi = 96;

        displayManager = {
          lightdm = {
            enable = true;
            background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
            # background = "/home/jb/.wallpapers/wallhaven-6krmxw.jpg";
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
        videoDrivers = ["nvidia"];

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
    # programs.zsh.enable = true;
    # programs.bash.enable = true;

    hardware = {
      video.hidpi.enable = true;
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

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
