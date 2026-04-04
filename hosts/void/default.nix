{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    ./packages.nix
  ];

  # Nix & Nixpkgs Configuration
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true; # Deduplicates files in the store to save space
    builders-use-substitutes = true; # Allow builders to use binary cache which speeds up builds
  };

  # Automatic Garbage Collection (Disabled in favor of programs.nh.clean)
  nix.gc = {
    automatic = false;
  };

  # Enable man-pages documentation for development
  documentation.dev.enable = true;
  # documentation.man.generateCaches = true;
  documentation.man.cache.enable = true;

  # Nix Helper (nh) for faster rebuilds
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/cipher/.dotfiles";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["libsoup-2.74.3"];
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

  # Boot & Kernel
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        # efiSysMountPoint = "/boot/efi";
      };
      # grub = {
      # enable = true;
      # efiSupport = true;
      # device = "nodev";
      # useOSProber = true;
      # theme = pkgs.sleek-grub-theme.override {withStyle = "dark";};
      # };
      systemd-boot.enable = true; # why should delete: Conflicting bootloader. We chose GRUB for themes/compatibility.
      systemd-boot.configurationLimit = 5;
    };

    # why should delete: Duplicates/Alternatives to our chosen cachyos-lto kernel
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelPackages = pkgs.linuxPackages_zen;
    # boot.kernelPackages = pkgs.linuxPackages_cachyos;
    # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_cachyos-lto;

    kernelParams = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "nowatchdog" # Disable watchdog to reduce CPU interrupts
      "nmi_watchdog=0" # Disable NMI watchdog
    ];

    # Resume from hibernation
    # resumeDevice = "/dev/disk/by-uuid/19cc334f-199e-46e8-8e3c-32cb6e8636ac";
    # resumeDevice = "/dev/disk/by-label/SWAP";
    kernel.sysctl = {
      "kernel.yama.ptrace_scope" = 0;
      # Optimize Network (TCP BBR)
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  # Performance & Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # Prevent system freezes during high memory load
  services.earlyoom.enable = true;

  # zramSwap.enable = true; # Enable ZRAM to compress RAM usage, improving system responsiveness

  # SCX Scheduler: Uses BPF to provide better process scheduling
  services.scx = {
    enable = true;
    scheduler = "scx_lavd"; # Optimized for gaming and desktop latency
  };

  # Hardware & Drivers
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.system76.enableAll = true;
  services.power-profiles-daemon.enable = false;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.Policy.AutoEnable = true;
  };
  services.blueman.enable = true;

  hardware.keyboard.zsa.enable = true;

  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
  };

  # Networking & Location
  networking.hostName = "void";
  networking.networkmanager.enable = true;

  # why should delete: Redundant networking options usually managed by NetworkManager
  # networking.wireless.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  time.timeZone = "America/Chicago";
  location.provider = "geoclue2";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Security & Secrets
  security.polkit.enable = true;

  security.pam.services = {
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/cipher/.config/sops/age/keys.txt";
    secrets.msmtp-password = {
      owner = config.users.users."cipher".name;
      neededForUsers = true;
    };
  };

  # Users
  users.users."cipher" = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input" "video" "jackaudio"];
    packages = with pkgs; [tree];
  };

  # Desktop Environment & Display Manager
  services.displayManager.ly = {
    enable = true;
    settings.animation = "matrix";
  };
  services.getty.autologinUser = "cipher";

  # why should delete: Redundant X11/GNOME settings replaced by Ly and Hyprland
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.enable = true;
  # services.xserver.xkb.layout = "us";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Gnome & Desktop Services
  services.desktopManager.gnome.enable = true;
  services.gvfs.enable = true;
  services.udev.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.passSecretService.enable = true;
  services.accounts-daemon.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  services.dbus = {
    enable = true;
    packages = with pkgs; [dconf gcr gnome2.GConf udisks2];
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-shell
    gnome-browser-connector
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
  };

  # Theming (Stylix)
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

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
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
      gtk.enable = false;
      grub.enable = false; # why should delete: Using custom sleek-grub-theme instead of Stylix's auto-generation
    };
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka
      nerd-fonts.fira-code
      nerd-fonts.geist-mono
      font-awesome
      material-design-icons
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
        autohint = true;
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };

  # Programs & Services
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*" "-3297:4976"];
        settings = {
          main = {
            # capslock = "layer(control)";
            capslock = "esc";
            a = "overloadi(a, overloadt2(meta, a, 200), 150)";
            s = "overloadi(s, overloadt2(alt, s, 200), 150)";
            d = "overloadi(d, overloadt2(shift, d, 200), 150)";
            f = "overloadi(f, overloadt2(control, f, 200), 150)";

            l = "overloadi(l, overloadt2(alt, l, 200), 150)";
            k = "overloadi(k, overloadt2(shift, k, 200), 150)";
            j = "overloadi(j, overloadt2(control, j, 200), 150)";

            g = "overloadi(g, overloadt2(symb, g, 200), 150)";
            h = "overloadi(h, overloadt2(symb, h, 200), 150)";
            v = "overloadi(v, overloadt2(num, v, 200), 150)";
            m = "overloadi(m, overloadt2(num, m, 200), 150)";
          };
          symb = {
            w = "<";
            e = "=";
            r = ">";
            t = "@";
            y = "`";
            u = "[";
            i = "_";
            o = "]";

            s = "(";
            d = "-";
            f = ")";
            g = "+";
            h = "%";
            j = "{";
            k = ";";
            l = "}";

            z = "$";
            x = "*";
            c = ":";
            v = "/";
            b = "#";
            n = "^";
            m = "|";
          };
          num = {
            q = "-";
            w = "5";
            e = "2";
            r = "3";
            t = "@";
            u = "[";
            o = "]";

            a = "7";
            s = ".";
            d = "1";
            f = "0";
            g = "4";
            h = "{";
            j = "C";
            k = "B";
            l = "A";

            z = "$";
            x = "6";
            c = "9";
            v = "8";
            b = "/";
            n = "+";
            m = "[";
          };
          otherlayer = {};
        };
        extraConfig = ''
          [main]
          ; = overloadi(;, overloadt2(meta, ;, 200), 150);

          [symb]
          a = \
          ; = !
          , = ~
          . = &

          [num]
          ; = }
          , = ]
          . = %
        '';
      };
    };
  };
  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.speechd.enable = true;

  services.nextdns = {
    enable = true;
    arguments = ["-config" "59e1db" "-report-client-info" "-auto-activate"];
  };
  systemd.services.nextdns.serviceConfig.TimeoutStopSec = "5s";

  programs.fuse.userAllowOther = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash.blesh.enable = true;
  programs.gamemode.enable = true;

  programs.foot = {
    theme = "nvim-dark";
    enableBashIntegration = true;
  };

  # services.adguardhome = {
  #   enable = true;
  #   # You can select any ip and port, just make sure to open firewalls where needed
  #   host = "127.0.0.1";
  #   port = 3003;
  #   settings = {
  #     dns = {
  #       upstream_dns = [
  #         # Example config with quad9
  #         "9.9.9.9#dns.quad9.net"
  #         "149.112.112.112#dns.quad9.net"
  #         # Uncomment the following to use a local DNS service (e.g. Unbound)
  #         # Additionally replace the address & port as needed
  #         # "127.0.0.1:5335"
  #       ];
  #     };
  #     filtering = {
  #       protection_enabled = true;
  #       filtering_enabled = true;
  #
  #       parental_enabled = false; # Parental control-based DNS requests filtering.
  #       safe_search = {
  #         enabled = false; # Enforcing "Safe search" option for search engines, when possible.
  #       };
  #     };
  #     # The following notation uses map
  #     # to not have to manually create {enabled = true; url = "";} for every filter
  #     # This is, however, fully optional
  #     filters =
  #       map (url: {
  #         enabled = true;
  #         url = url;
  #       }) [
  #         "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
  #         "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
  #       ];
  #   };
  # };

  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];

  # why should delete: Redundant or moved to other modules/imports
  # programs.git = { ... };
  # programs.firefox.enable = true;
  # programs.mtr.enable = true;

  # Environment
  environment.sessionVariables = {
    EDITOR = "nvim";
    MOZ_USE_XINPUT2 = "1";
    MANPAGER = "nvim +Man!";
  };

  # System
  # systemd.sleep.extraConfig = "HibernateDelaySec=2h";
  # systemd.sleep.settings.Sleep
  system.activationScripts.binbash = {
    deps = ["binsh"];
    text = "ln -sf /bin/sh /bin/bash";
  };

  system.stateVersion = "26.05";
}
