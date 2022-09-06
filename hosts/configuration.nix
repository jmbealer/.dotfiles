{ config, lib, pkgs, inputs, user, location, ...}:

{
  imports = [
    ../modules/editors/emacs
    ./hostsBlock.nix
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd"];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzlS2DsemrWjubPRw5WzqYYJOvWjLzYwBslvUpnzVkX jmbealer11@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.rtkit.enable = true;
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };

  fonts.fonts = with pkgs; [
    carlito
    vegur
    source-code-pro
    jetbrains-mono
    font-awesome
    corefonts
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
      # EDITOR = "nvim";
      EDITOR = "vim";
      VISUAL = "vim";
      # VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # vim
      # git
      killall
      pciutils
      usbutils
      wget

      nodejs
      nodePackages.npm
      nodePackages.bash-language-server
    ];
  };

  services = {
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

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "21.11";
  };
}
