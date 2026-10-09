{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Shared baseline applied to every machine.
  # Machine-specific settings live in hosts/<hostname>/default.nix.

  # Nix & Nixpkgs Configuration
  nix = {
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
  }; # end of nixpkgs

  boot.kernel.sysctl = {
    "kernel.yama.ptrace_scope" = 0;
    # Optimize Network (TCP BBR)
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # Performance & Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  services = {
    # Prevent system freezes during high memory load
    earlyoom.enable = true;

    # zramSwap.enable = true; # Enable ZRAM to compress RAM usage, improving system responsiveness

    power-profiles-daemon.enable = false;
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

    # Gnome & Desktop Services (for GNOME apps under Hyprland)
    desktopManager.gnome.enable = true;
    gvfs.enable = true;
    udev = {
      enable = true;
    };
    udisks2.enable = true;
    devmon.enable = true;
    passSecretService.enable = true;
    accounts-daemon.enable = true;
    gnome.gnome-online-accounts.enable = true;

    dbus = {
      enable = true;
      packages = with pkgs; [dconf udisks2];
    };

    fstrim.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    speechd.enable = true;
  }; # end of services

  hardware = {
    # Hardware & Drivers
    graphics.enable = true;
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.Policy.AutoEnable = true;
    };
  }; # end of hardware

  networking.networkmanager.enable = true;

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

  environment = {
    # Environment
    sessionVariables = {
      EDITOR = "nvim";
      MOZ_USE_XINPUT2 = "1";
      MANPAGER = "nvim +Man!";
    };

    gnome.excludePackages = with pkgs; [
      gnome-shell
    ];
  }; # end of environment

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

  system.stateVersion = "26.05";
}
