{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    ./packages.nix
  ];

  # ============================================================================
  # Nix & Nixpkgs Configuration
  # ============================================================================
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gfinal: gprev: {
        gvfs = gprev.gvfs.override {
          googleSupport = true;
          gnomeSupport = true;
        };
      });
    })
  ];

  # ============================================================================
  # Boot & Kernel
  # ============================================================================
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      extraConfig = ''
        GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.nvidia_modeset=1";
      '';
    };
    # systemd-boot.enable = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  boot.kernelParams = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;

  # ============================================================================
  # Hardware & Drivers
  # ============================================================================
  hardware.graphics.enable = true;
  # hardware.nvidia.open = false;
  hardware.system76.enableAll = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    # nvidiaSettings = false;
    # package = pkgs.linuxPackages_cachyos-lto.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;

  hardware.keyboard.zsa.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  # services.libinput.mouse.naturalScrolling = true;

  # ============================================================================
  # Networking & Location
  # ============================================================================
  networking.hostName = "myhost";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  time.timeZone = "America/Chicago";
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  location.provider = "geoclue2";
  # services.geoclue3.enable = true;

  # ============================================================================
  # Audio
  # ============================================================================
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # services.pulseaudio.enable = true;

  services.jack = {
    jackd.enable = true;
    alsa.enable = true;
    # loopback = {
    #   enable = true;
    # };
  };

  # ============================================================================
  # Security & Secrets
  # ============================================================================
  security.polkit.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/0xjb/.config/sops/age/keys.txt";
  sops.secrets.msmtp-password = {
    owner = config.users.users."0xjb".name;
    neededForUsers = true;
  };
  # sops.secrets.Zxjb.neededForUsers = true;
  # sops.secrets."0xjb".neededForUsers = true;

  # ============================================================================
  # Users
  # ============================================================================
  # users.mutableUsers = false;
  users.users."0xjb" = {
    isNormalUser = true;
    # hashedPasswordFile = config.sops.secrets.Zxjb-password.path;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
      "jackaudio"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  # ============================================================================
  # Desktop Environment & Display Manager
  # ============================================================================
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
    };
  };
  services.getty.autologinUser = "0xjb";

  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.enable = true;
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Gnome Services & Desktop Integration
  services.desktopManager.gnome.enable = true;
  # services.desktopManager.plasma6.enable = true;

  services.dbus = {
    enable = true;
    packages = with pkgs; [
      dconf
      gcr
      gnome2.GConf
      udisks2
    ];
  };

  services.gvfs.enable = true;
  # services.gvfs.package = lib.mkForce pkgs.gnome.gvfs;

  services.udev.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # services.gnome.gnome-keyring.enable = true;
  services.passSecretService.enable = true;
  # services.gnome.gnome-settings-daemon.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.accounts-daemon.enable = true;
  # services.gnome.glib-networking.enable = true;
  # services.gnome.core-os-services.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-shell
    gnome-browser-connector
    # gnome-gsettings
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      # pkgs.xdg-desktop-portal
      xdg-desktop-portal-hyprland
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  # ============================================================================
  # Theming (Stylix) & Fonts
  # ============================================================================
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/3024.yaml";
    polarity = "dark";

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
      sha256 = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
    };

    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.geist-mono;
        name = "GeistMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 12;
        popups = 12;
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 0.95;
    };

    targets = {
      gnome.enable = false;
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   style = "kvantum";
  # };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    font-awesome
    material-design-icons
  ];

  # ============================================================================
  # Programs & Services
  # ============================================================================
  # services.scx = {
  # enable = true;
  # scheduler = "scx_rusty";
  # };

  services.keyd.enable = true;

  services.openssh.enable = true;

  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  programs.fuse.userAllowOther = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash.blesh.enable = true;

  programs.foot = {
    theme = "nvim-dark";
    enableBashIntegration = true;
  };

  # programs.mango.enable = true;
  # programs.lazyvim.enabled = true;
  # imports = [ lazyvim.nixosModules.lazyvim ];

  # programs.git = {
  #   enable = true;
  #   extraConfig = {
  #     user.name = "jmbealer";
  #     user.email = "jmbealer11@gmail.com";
  #     init.defaultBranch = "main";
  #   };
  # };

  # programs.firefox.enable = true;
  # programs.mtr.enable = true;

  # ============================================================================
  # Environment & System Packages
  # ============================================================================
  environment.sessionVariables = {
    EDITOR = "nvim";
    # VISUAL = "nvim";
    # gitUsername = "jmbealer";
    MOZ_USE_XINPUT2 = "1";
    MANPAGER = "bat -plman";
  };

  # ============================================================================
  # System
  # ============================================================================
  # system.copySystemConfiguration = true;
  system.stateVersion = "25.05";
}
