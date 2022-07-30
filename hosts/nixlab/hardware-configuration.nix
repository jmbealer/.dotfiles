{ config, lib, pkgs, modulesPath, ... }:
# { config, lib, pkgs, inputs, modulesPath, ... }:

{imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "nvme"  "rtsx_pci_sdmmc"];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. Don't copy this blindly! And especially not for
      #      mission critical or server/headless builds exposed to the world.
      # "mitigations=off"
    ];

    # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
    # pinging them, unlike my servers.
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };

  # Modules
  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    ergodox.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = true;
    sensors.enable = true;
  };

  # CPU
  # nix.settings.max-jobs = lib.mkDefault 10;
  nix.settings.max-jobs = lib.mkDefault 16;
  hardware.cpu.amd.updateMicrocode = true;
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # performance gives better battery life/perf than ondemand on sandy bridge and
  # newer because of intel pstates.
  powerManagement.cpuFreqGovernor = "performance";
  # Without this wpa_supplicant may fail to auto-discover wireless interfaces at
  # startup (and must be restarted).
  networking.interfaces = {
    enp4s0f1.useDHCP = true;
    wlp5s0.useDHCP = true;
  };


  # Storage
  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };
    "/home" = {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };
    "/nix" = {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/218A-E5C2";
      fsType = "vfat";
    };
  };
  swapDevices =
    [ { device = "/dev/disk/by-uuid/bc5b3d46-51ea-47e9-a15a-a8bade508619"; } ];
}
