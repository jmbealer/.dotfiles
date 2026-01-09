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
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/0xjb/.config/sops/age/keys.txt";
  sops.secrets.msmtp-password = {
    owner = config.users.users."0xjb".name;
    neededForUsers = true;
  };

  # imports = [ lazyvim.nixosModules.lazyvim ];
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
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
  };

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;

  networking.hostName = "myhost"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  security.polkit.enable = true;

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

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  environment.sessionVariables = {
    EDITOR = "nvim";
    # VISUAL = "nvim";
    # gitUsername = "jmbealer";
    MOZ_USE_XINPUT2 = "1";
  };

  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  # services.libinput.mouse.naturalScrolling = true;

  services.getty.autologinUser = "0xjb";

  services.keyd = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  # hardware.nvidia.open = false;
  hardware.system76.enableAll = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    # nvidiaSettings = false;
  };

  hardware.keyboard.zsa.enable = true;

  services.jack = {
    jackd.enable = true;
    alsa.enable = true;
    # loopback = {
    #   enable = true;
    # };
  };

  programs.mango.enable = true;
  programs.bash.blesh.enable = true;

  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
  # services.geoclue3.enable = true;
  location.provider = "geoclue2";

  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   style = "kvantum";
  # };

  # programs.lazyvim.enabled = true;

  environment.systemPackages = with pkgs; [
    # terminal
    foot
    vim # neovim
    git
    ripgrep
    fd # or fdfind
    fzf
    gcc
    unzip
    wget
    lazygit
    pfetch-rs
    bat
    eza
    zoxide
    zellij
    gitui
    dust
    dua
    starship
    delta
    ripgrep-all
    wiki-tui
    lscolors
    tealdeer
    keymapp
    yazi
    yaziPlugins.starship
    sops
    # bash-debug-adapter
    # bashdb
    remnote

    # window manager
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    firefox
    waybar
    keyd

    lua
    python3

    pavucontrol
    qjackctl
    blueman
    redshift

    material-cursors
    lyra-cursors
    adwaita-qt
    adwaita-icon-theme
    lm_sensors
    # nixfmt-rfc-style
    alejandra
    # nixd
    nil
    tree-sitter
    lua-language-server
    nodejs
    unrar
    usbutils
    nwg-displays
    nwg-drawer
    nwg-look

    ungoogled-chromium
    microsoft-edge
    floorp-bin
    statix

    entr

    # gnome core libraries
    gtk3
    gtk4
    libadwaita
    adwaita-icon-theme

    # inputs.Akari.packages.${system}.default
    github-copilot-cli

    # gnome runtime services
    dconf
    gnome-keyring
    gvfs
    # gnome.gvfs
    google-drive-ocamlfuse
    # gvfs-smb
    # gvfs-nfs
    # gvfs-mtp

    # xdg portals for wayland
    xdg-desktop-portal
    xdg-desktop-portal-gnome

    nautilus

    gnome-control-center
    gnome-system-monitor
    gnome-disk-utility
    gnome-online-accounts
    wrapGAppsHook4
    gsettings-desktop-schemas
    glib
    glib-networking
    gnome-settings-daemon
    # gnome-session
    # gvfs-goa
    # gvfs-google
    #
    #
    gh
    codex

    # dircolors
    # maybes
    # xh
    # hyperfine
    # fselect
    # ncspot
    # tokei

    # (python3.withPackages (python-pkgs: with python-pkgs; [
    # pip
    # ]))

    ruff

    (yazi.override {
      _7zz = _7zz-rar;
    })

    nix-bash-completions
  ];

  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;

  services.dbus = {
    enable = true;
    packages = with pkgs; [
      dconf
      gcr
      gnome2.GConf
      udisks2
    ];
  };
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };
  services.udev.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.passSecretService.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.accounts-daemon.enable = true;
  services.gnome.glib-networking.enable = true;
  services.gnome.core-os-services.enable = true;

  programs.fuse.userAllowOther = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs.foot.theme = "nvim-dark";
  programs.foot.enableBashIntegration = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka
    nerd-fonts.fira-code
  ];

  # sops.secrets.Zxjb.neededForUsers = true;
  # sops.secrets."0xjb".neededForUsers = true;
  # users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."0xjb" = {
    isNormalUser = true;
    # hashedPasswordFile = config.sops.secrets.Zxjb-password.path;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
      "jackaudio"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  stylix = {
    enable = true;
    # autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/3024.yaml";

    # neovim.plugin = "base16-nvim";

    # gtk = {
    #   enable = true;
    #   theme.name = "Adwaita-dark";
    #   iconTheme.name = "Papirus-Dark";
    # };

    targets = {
      gtk.enable = true;
      qt.enable = true;
      # neovim.plugin = "base16-nvim";
      # neovim.enable = false;
      # bash.enable = true;
      # floorp.profileNames = [ "default" ];
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 24;
    };

    fonts = {
      monospace = {
        # packages =
        name = "IosevkaTerm NF";
      };
      # serif = {
      #   packages = pkgs.dejavu_fonts;
      #   name = "DejaVu Serif";
      # };
      # sansSerif = {
      #   packages = pkgs.dejavu_fonts;
      #   name = "DejaVu Sans";
      # };
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 12;
        popups = 12;
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    polarity = "dark";
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
    };
  };

  # programs.git = {
  #   enable = true;
  #   extraConfig = {
  #     user.name = "jmbealer";
  #     user.email = "jmbealer11@gmail.com";
  #     init.defaultBranch = "main";
  #   };
  # };

  # programs.firefox.enable = true;

  # nix.settings.auto-optimise-store = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.05"; # Did you read the comment?
}
