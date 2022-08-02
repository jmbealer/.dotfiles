{ config, pkgs, lib, user, ... }:

{
  imports = 
    [(import ./hardware-configuration.nix)] ++
    # [(import ../../modules/desktop/bspwm/default.nix)] ++
    (import ../../modules/desktop) ++
    (import ../../modules/hardware);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "nvidia" ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      # systemd-boot.enable = true;
      # efi = {
        # canTouchEfiVariables = true;
        # efiSysMountPoint = "/boot";
      # };
      # grub = {
        # enable = true;
        # version = 2;
        # devices = [ "nodev" ];
        # efiSupport = true;
        # useOSProber = true;
        # configurationLimit = 5;
      # };
      timeout = 1;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      discord
    ];
  };

  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services = {
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
