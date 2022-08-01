{ config, pkgs, lib, user, ... }

{
  imports = 
    [(import ./hardware-configuration.nix)] ++
    (import ../../modules/desktop) ++
    (import ../../modules/hardware);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        verison = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
      };
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
    samba = {
      enable = true;
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true
    };
  };

}
