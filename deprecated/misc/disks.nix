# Disko partition layout for serval (System76 Serval WS).
#
# Storage is fully declarative: fileSystems, swapDevices and
# boot.resumeDevice are generated from this file (the corresponding
# options in hardware.nix / default.nix were removed).
#
# NOTE — multi-device Btrfs: the "NIXOS" Btrfs filesystem spans BOTH
# NVMe drives (nvme0n1p3 = devid 1, nvme1n1p3 = devid 2). Disko
# cannot create multi-device Btrfs, so on a FRESH install:
#   1. Run disko (creates a single-device Btrfs on nvme0n1p3)
#   2. Add the second member manually before installing:
#        mount /dev/disk/by-partlabel/NIXOS /mnt -o subvol=/
#        btrfs device add /dev/disk/by-partlabel/NIXOS-SEC /mnt
#
# Running disko on the already-provisioned disks is a safe no-op:
# existing partitions are adopted and existing filesystems are
# never reformatted.
#
# Apply:  sudo nix run nixpkgs#disko -- -s /home/cipher/.dotfiles/hosts/serval/disks.nix
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              label = "BOOT";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n" "BOOT" ];
                mountpoint = "/boot";
                # Fix world-accessible random seed security warning
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            swap = {
              priority = 2;
              label = "SWAP";
              size = "80G";
              content = {
                type = "swap";
                extraArgs = [ "-L" "swap1" ];
                priority = 10;
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              label = "NIXOS";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "NIXOS" ];
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" ];
                  };
                  "@games" = {
                    mountpoint = "/games";
                    mountOptions = [ "nodatacow" "noatime" "discard=async" ];
                  };
                  "@vms" = {
                    mountpoint = "/vms";
                    mountOptions = [ "nodatacow" "noatime" "discard=async" ];
                  };
                  "@snapshots" = {
                    mountpoint = "/snapshots";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" ];
                  };
                };
              };
            };
          };
        };
      };

      nvme1n1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            # Unused secondary ESP (kept for layout parity)
            ESP = {
              priority = 1;
              label = "BOOTSEC";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                # No mountpoint: created but never mounted
              };
            };
            swap = {
              priority = 2;
              label = "SWAP-SEC";
              size = "80G";
              content = {
                type = "swap";
                extraArgs = [ "-L" "swap2" ];
                priority = 10;
              };
            };
            # Second member of the multi-device Btrfs "NIXOS" (devid 2).
            # Declared WITHOUT content on purpose: Disko must never format
            # it. Added to the Btrfs manually with `btrfs device add`
            # (see the header comment above).
            nixosSec = {
              size = "100%";
              label = "NIXOS-SEC";
            };
          };
        };
      };
    };
  };
}
