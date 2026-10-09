{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Machine-specific configuration for serval (System76 Serval WS).
  # Shared settings are imported from hosts/common/.
  imports = [
    ../common/default.nix
    ../common/users.nix
    ./hardware.nix
    inputs.sops-nix.nixosModules.sops
    ./packages.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/stylix.nix
    ../../modules/nixos/services/keyd.nix
    ../../modules/nixos/services/nextdns.nix
  ];

  # Boot & Kernel
  boot = {
    # Bootloader
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };

    # kernelPackages = pkgs.linuxPackages_cachyos-lto;
    kernelPackages = pkgs.linuxPackages_cachyos-gcc;

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
  }; #end of boot

  services = {
    # SCX Scheduler: Uses BPF to provide better process scheduling
    scx = {
      enable = true;
      scheduler = "scx_lavd"; # Optimized for gaming and desktop latency
    };

    xserver.videoDrivers = ["nvidia"];

    # Desktop Environment & Display Manager
    displayManager.ly = {
      enable = true;
      settings.animation = "matrix";
    };

    # why should delete: Redundant X11/GNOME settings replaced by Ly and Hyprland
    # xserver.desktopManager.gnome.enable = true;
    # xserver.displayManager.gdm.enable = true;
    # xserver.enable = true;
    # xserver.xkb.layout = "us";

    # System76 backlight permissions
    udev = {
      extraRules = ''
        # Allow members of the 'video' group to modify screen backlight
        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"

        # Allow members of the 'backlight' group to modify keyboard backlight
        ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp backlight /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
        ACTION=="add", SUBSYSTEM=="leds", KERNEL=="system76::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp backlight /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
      '';
    };
  }; # end of services

  hardware = {
    system76.enableAll = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false; # testing false
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.latest;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    keyboard.zsa.enable = true;
  }; # end of hardware

  networking = {
    # Networking & Location
    hostName = "serval";
    # why should delete: Redundant networking options usually managed by NetworkManager
    # wireless.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # firewall.enable = false;
    firewall.allowedTCPPorts = [53];
    firewall.allowedUDPPorts = [53];
  }; # end of networking

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
    # sleep.extraConfig = "HibernateDelaySec=2h";
    # sleep.settings.Sleep
  }; # end of systemd

  # System
  system.activationScripts.binbash = {
    deps = ["binsh"];
    text = "ln -sf /bin/sh /bin/bash";
  };
}
