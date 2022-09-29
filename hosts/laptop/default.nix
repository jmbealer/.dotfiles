#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix       
#   └─ ./modules
#       ├─ ./desktop
#       │   └─ ./hyprland
#       │       └─ hyprland.nix
#       ├─ ./modules
#       │   └─ ./programs
#       │       └─ waybar.nix
#       └─ ./hardware
#           └─ default.nix

{ config, pkgs, lib, user, ... }: {
  # For now, if applying to other system, swap files
  imports =
    # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ./hardware-configuration.nix)] ++
    # [(import ../../modules/desktop/bspwm/default.nix)] ++
    # Window Manager
    (import ../../modules/desktop) ++
    # Hardware devices
    (import ../../modules/hardware);

  # Boot options
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "nvidia" ];
    # EFI Boot
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      # systemd-boot = {
        # enable = true;
        # configurationLimit = 10;
      # };

      # systemd-boot.enable = true;
      # efi = {
        # canTouchEfiVariables = true;
        # efiSysMountPoint = "/boot";
      # };
      # Most of grub is set up for dual boot
      grub = {
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        # Find all boot options
        useOSProber = true;
        configurationLimit = 10;
      };
      # Grub auto select time
      timeout = 1;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # nixFlakes
      # discord
    ];
  };
  # No xbacklight, this is the alternative
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    # TLP and auto-cpufreq for power management
    tlp.enable = true;
    # Laptop does not go to sleep when lid is closed
    logind.lidSwitch = "ignore";
    auto-cpufreq.enable = true;
    blueman.enable = true;
    # samba = {
      # enable = true;
      # shares = {
        # share = {
          # "path" = "/home/${user}";
          # "guest ok" = "yes";
          # "read only" = "no";
        # };
      # };
      # openFirewall = true;
    # };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];

}
