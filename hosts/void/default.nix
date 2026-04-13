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

  nix = {
    # Nix & Nixpkgs Configuration
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true; # Deduplicates files in the store to save space
      builders-use-substitutes = true; # Allow builders to use binary cache which speeds up builds
    };

    # Automatic Garbage Collection (Disabled in favor of programs.nh clean)
    gc = {
      automatic = false;
    };
  }; # end of nix

  documentation = {
    # Enable man-pages documentation for development
    dev.enable = true;
    # man.generateCaches = true;
    man.cache.enable = true;
  }; # end of documentation

  programs = {
    # Nix Helper (nh) for faster rebuilds
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "/home/cipher/.dotfiles";
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    fuse.userAllowOther = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    bash.blesh.enable = true;
    gamemode.enable = true;

    foot = {
      theme = "nvim-dark";
      enableBashIntegration = true;
    };
  }; # end of programs

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = ["libsoup-2.74.3"];
    };
    overlays = [
      (final: prev: {
        gnome = prev.gnome.overrideScope (gfinal: gprev: {
          gvfs = gprev.gvfs.override {
            googleSupport = true;
            gnomeSupport = true;
          };
        });
        #   anki = prev.anki.overrideAttrs (oldAttrs: {
        #     makeWrapperArgs = (oldAttrs.makeWrapperArgs or []) ++ [
        #       "--prefix PYTHONPATH : ${prev.speechd}/lib/python3.13/site-packages"
        #     ];
        #   });
      })
    ];
  }; # end of nixpkgs

  boot = {
    # Boot & Kernel
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };

    kernelPackages = pkgs.linuxPackages_cachyos-lto;

    kernelParams = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "nowatchdog" # Disable watchdog to reduce CPU interrupts
      "nmi_watchdog=0" # Disable NMI watchdog
      "initcall_blacklist=amd_pstate_init" # Disable amd_pstate as CPU lacks CPPC support (prevents boot errors)
      "module_blacklist=ucsi_ccg" # Disable Nvidia USB-C controller to fix I2C timeout errors
    ];

    # Resume from hibernation
    # resumeDevice = "/dev/disk/by-uuid/19cc334f-199e-46e8-8e3c-32cb6e8636ac";
    resumeDevice = "/dev/disk/by-uuid/1d34d2be-f4cd-46c5-9cb3-9aa0cb0949ba";
    # resumeDevice = "/dev/disk/by-label/SWAP";

    kernel.sysctl = {
      "kernel.yama.ptrace_scope" = 0;
      # Optimize Network (TCP BBR)
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  }; #end of boot

  # Performance & Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  services = {
    # Prevent system freezes during high memory load
    earlyoom.enable = true;

    # zramSwap.enable = true; # Enable ZRAM to compress RAM usage, improving system responsiveness

    # SCX Scheduler: Uses BPF to provide better process scheduling
    scx = {
      enable = true;
      scheduler = "scx_lavd"; # Optimized for gaming and desktop latency
    };
    power-profiles-daemon.enable = false;
    xserver.videoDrivers = ["nvidia"];
    blueman.enable = true;
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    gnome.gnome-keyring.enable = true; # Fix 'gkr-pam: unable to locate daemon control file'
    # Desktop Environment & Display Manager
    displayManager.ly = {
      enable = true;
      settings.animation = "matrix";
    };
    getty.autologinUser = "cipher";

    # why should delete: Redundant X11/GNOME settings replaced by Ly and Hyprland
    # xserver.desktopManager.gnome.enable = true;
    # xserver.displayManager.gdm.enable = true;
    # xserver.enable = true;
    # xserver.xkb.layout = "us";
    # Gnome & Desktop Services
    desktopManager.gnome.enable = true;
    gvfs.enable = true;
    udev = {
      enable = true;
      extraRules = ''
        # Allow members of the 'video' group to modify screen backlight
        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"

        # Allow members of the 'backlight' group to modify keyboard backlight
        ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp backlight /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
        ACTION=="add", SUBSYSTEM=="leds", KERNEL=="system76::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp backlight /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
      '';
    };
    udisks2.enable = true;
    devmon.enable = true;
    passSecretService.enable = true;
    accounts-daemon.enable = true;
    gnome.gnome-online-accounts.enable = true;

    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr gnome2.GConf udisks2];
    };
    keyd = {
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
    fstrim.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    speechd.enable = true;

    nextdns = {
      enable = true;
      arguments = ["-config" "59e1db" "-report-client-info" "-auto-activate"];
    };
    # adguardhome = {
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
  }; # end of services

  hardware = {
    # Hardware & Drivers
    graphics.enable = true;
    enableRedistributableFirmware = true;
    system76.enableAll = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.Policy.AutoEnable = true;
    };

    keyboard.zsa.enable = true;
  }; # end of hardware

  networking = {
    # Networking & Location
    hostName = "void";
    networkmanager.enable = true;
    # why should delete: Redundant networking options usually managed by NetworkManager
    # wireless.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # firewall.enable = false;
    firewall.allowedTCPPorts = [53];
    firewall.allowedUDPPorts = [53];
  }; # end of networking

  time.timeZone = "America/Chicago";
  location.provider = "geoclue2";

  security = {
    # Audio
    rtkit.enable = true;

    # Security & Secrets
    polkit.enable = true;

    pam.services = {
      login.enableGnomeKeyring = true;
      gdm.enableGnomeKeyring = true;
    };
  }; # end of security

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
    extraGroups = ["wheel" "networkmanager" "input" "video" "backlight" "system76" "jackaudio"];
    packages = with pkgs; [tree];
  };

  systemd = {
    # Keyboard Backlight Configuration (System76)
    services.keyboard-backlight = {
      description = "Set keyboard backlight to red and 50% brightness";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "set-kb-backlight" ''
          # Set all zones to Red (FF0000)
          for zone in left center right extra; do
            if [ -f /sys/class/leds/system76::kbd_backlight/color_$zone ]; then
              echo "FF0000" > /sys/class/leds/system76::kbd_backlight/color_$zone
            fi
          done
          # Set brightness to 50% (approx 128 out of 255)
          ${pkgs.brightnessctl}/bin/brightnessctl -d "system76::kbd_backlight" set 50%
        '';
      };
    };
    # Programs & Services
    user.services.swaync.enable = false; # Disable auto-start service; handled by Hyprland autostart.conf
    services.nextdns.serviceConfig.TimeoutStopSec = "5s";
    # sleep.extraConfig = "HibernateDelaySec=2h";
    # sleep.settings.Sleep
  }; # end of systemd

  environment = {
    # Environment
    sessionVariables = {
      EDITOR = "nvim";
      MOZ_USE_XINPUT2 = "1";
      MANPAGER = "nvim +Man!";
    };

    gnome.excludePackages = with pkgs; [
      gnome-shell
      gnome-browser-connector
    ];
  }; # end of environment

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

  # System
  system = {
    activationScripts.binbash = {
      deps = ["binsh"];
      text = "ln -sf /bin/sh /bin/bash";
    };

    stateVersion = "26.05";
  }; #end of system
}
