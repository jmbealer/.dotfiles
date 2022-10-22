# Main system configuration.
# More information available configuration.nix(5) man page.
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix
{ config, lib, pkgs, inputs, user, location, ...}: {

  # Import window or display manager.
  imports = [
    ../modules/editors/emacs
    ./hostsBlock.nix
  ];

  # System User
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" ];
    # Default shell
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzlS2DsemrWjubPRw5WzqYYJOvWjLzYwBslvUpnzVkX jmbealer11@gmail.com"
    ];
  };

  documentation.nixos.enable = false;

  # User does not need to give password when using sudo.
  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    carlito
    vegur
    source-code-pro
    jetbrains-mono
    font-awesome
    corefonts
    # Nerdfont Icons override
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Iosevka"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "vim";
      VISUAL = "vim";
    };
    etc."dict.conf".text = "server dict.org";
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=desktop
      DOCUMENTS=documents
      DOWNLOAD=downloads
      MUSIC=music
      PICTURES=pictures
      PUBLICSHARE=public
      TEMPLATES=templates
      VIDEOS=videos
    '';
    # Default packages install system-wide
    systemPackages = with pkgs; [
      # vim
      # git
      killall
      pciutils
      usbutils
      wget

      # nodejs-slim-14_x
      nodejs
      nodePackages.npm
      nodePackages.bash-language-server

      nodePackages.vscode-langservers-extracted

    ];
  };

  services = {
    # Sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    openssh = {
      enable = true;
      # allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
    flatpak.enable = true;
    gvfs.enable = true;
  };

  # qt5 = {
    # enable = true;
    # platformTheme = "gtk2";
    # style = "gtk2";
  # };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    mime.enable = true;
  };

  # Nix Package Manager settings
  nix = {
    settings = {
      # Optimise syslinks
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes"];
    };
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # Enable nixFlakes on system
    # package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  # Allow proprietary software.
  nixpkgs.config.allowUnfree = true;

  # NixOS settings
  system = {
    # Allow auto update
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "21.11";
  };
}
