{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader and Kernel modules
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  
  # Early KMS for NVIDIA and support for software RAID
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelModules = [ "kvm-amd" "mdadm" ];
  boot.extraModulePackages = [ ];

  # Software RAID (mdadm) configuration for RAID0 setup
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md/nixos:0 level=raid0 num-devices=2 metadata=1.2 UUID=e8749858:5fe47547:6eb7ffee:562922db devices=/dev/nvme0n1p2,/dev/nvme1n1
      MAILADDR root
    '';
  };

  # Filesystem mounts
  # Root partition on RAID0
  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
    options = [ "noatime" "errors=remount-ro" "commit=60" ]; # Performance + Safety
  };

  # Secondary boot partition
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # EFI System Partition
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Separate home partition
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/31adb93e-2d32-4455-8256-7caed9ad75ec";
    fsType = "ext4";
    options = [ "noatime" "commit=60" ];
  };

  # Swap space for hibernation support
  swapDevices = [
    { 
      device = "/dev/disk/by-uuid/19cc334f-199e-46e8-8e3c-32cb6e8636ac";
      options = [ "defaults" "discard" ]; # Enable TRIM for SSD health
    }
  ];

  # Networking and Platform specific settings
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}