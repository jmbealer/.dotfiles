# NixOS Rebuild Guide: Btrfs RAID0 + Hibernation

**🚨 CRITICAL WARNING 🚨**
This process will **PERMANENTLY ERASE ALL DATA** on both `/dev/nvme0n1` and `/dev/nvme1n1`. 
You MUST back up your `.dotfiles`, SSH keys, `secrets.yaml` (and sops age key), and all personal files to an external drive before beginning.

**Prerequisites:**
1. Boot into a NixOS Live USB.
2. Ensure you have internet access in the live environment.
3. Switch to the root user: `sudo su`

---

### Step 1: Dismantle Current Setup & Wipe Drives

Stop the active software RAID and wipe all partition tables and filesystem signatures.

```bash
# Stop the mdadm RAID array
mdadm --stop /dev/md0

# Wipe all signatures and partition tables from both drives
wipefs -a -f /dev/nvme0n1
wipefs -a -f /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme1n1
```

---

### Step 2: Symmetrical Partitioning

We will create the exact same layout on both drives to ensure perfect symmetry for Btrfs RAID0.

**Drive 1 (`/dev/nvme0n1`):**
```bash
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI1" /dev/nvme0n1
sgdisk -n 2:0:+64G -t 2:8200 -c 2:"Swap1" /dev/nvme0n1
sgdisk -n 3:0:0 -t 3:8300 -c 3:"Btrfs1" /dev/nvme0n1
```

**Drive 2 (`/dev/nvme1n1`):**
```bash
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI2" /dev/nvme1n1
sgdisk -n 2:0:+64G -t 2:8200 -c 2:"Swap2" /dev/nvme1n1
sgdisk -n 3:0:0 -t 3:8300 -c 3:"Btrfs2" /dev/nvme1n1
```

---

### Step 3: Formatting

Format the partitions. Note that the Btrfs command combines the two large partitions into one RAID0 filesystem.

```bash
# Format EFI partitions
mkfs.vfat -F 32 -n BOOT1 /dev/nvme0n1p1
mkfs.vfat -F 32 -n BOOT2 /dev/nvme1n1p1

# Format Swap partitions
mkswap -L SWAP1 /dev/nvme0n1p2
mkswap -L SWAP2 /dev/nvme1n1p2

# Format Btrfs (Data=RAID0 for speed, Metadata=RAID1 for safety)
mkfs.btrfs -L NIXOS -d raid0 -m raid1 /dev/nvme0n1p3 /dev/nvme1n1p3 -f
```

---

### Step 4: Btrfs Subvolumes

Mount the top-level Btrfs pool to create subvolumes for system organization.

```bash
# Mount the pool temporarily
mount /dev/disk/by-label/NIXOS /mnt

# Create subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log

# Unmount the top-level pool
umount /mnt
```

---

### Step 5: Mount Everything for Installation

Mount the subvolumes with zstd compression and the dual boot/swap partitions.

```bash
# Mount Root subvolume
mount -o compress=zstd,subvol=@ /dev/disk/by-label/NIXOS /mnt

# Create directories
mkdir -p /mnt/{home,nix,var/log,boot/efi,boot/efi-fallback}

# Mount remaining subvolumes
mount -o compress=zstd,subvol=@home /dev/disk/by-label/NIXOS /mnt/home
mount -o compress=zstd,noatime,subvol=@nix /dev/disk/by-label/NIXOS /mnt/nix
mount -o compress=zstd,subvol=@log /dev/disk/by-label/NIXOS /mnt/var/log

# Mount Dual EFI partitions
mount /dev/disk/by-label/BOOT1 /mnt/boot/efi
mount /dev/disk/by-label/BOOT2 /mnt/boot/efi-fallback

# Enable Dual Swap partitions
swapon /dev/disk/by-label/SWAP1
swapon /dev/disk/by-label/SWAP2
```

---

### Step 6: Update NixOS Configuration

Before installing, you must update your `.dotfiles` to reflect the new layout.

1. **Generate new hardware config:**
   ```bash
   nixos-generate-config --root /mnt
   ```
   *Copy the contents of `/mnt/etc/nixos/hardware-configuration.nix` and replace your repository's version.*

2. **Clean up old mdadm config:**
   Ensure `boot.swraid = { enable = true; ... }` is **completely removed** from your configuration.

3. **Configure Hibernation & Dual Swap (`hardware-configuration.nix` or `default.nix`):**
   ```nix
   # Set primary swap as hibernation target
   boot.resumeDevice = "/dev/disk/by-label/SWAP1";

   # Configure both swaps with equal priority for striping performance
   swapDevices = [
     { device = "/dev/disk/by-label/SWAP1"; priority = 100; options = [ "defaults" "discard" ]; }
     { device = "/dev/disk/by-label/SWAP2"; priority = 100; options = [ "defaults" "discard" ]; }
   ];
   ```

4. **Configure Dual Boot (`default.nix`):**
   Update your bootloader section to use `mirroredBoots` instead of a single mount point.
   ```nix
   boot.loader = {
     efi.canTouchEfiVariables = true;
     grub = {
       enable = true;
       efiSupport = true;
       device = "nodev";
       useOSProber = true;
       # Add the mirroredBoots configuration
       mirroredBoots = [
         { devices = [ "nodev" ]; path = "/boot/efi"; }
         { devices = [ "nodev" ]; path = "/boot/efi-fallback"; }
       ];
     };
   };
   ```

---

### Step 7: Install NixOS

Copy your updated `.dotfiles` to `/mnt` (or clone them if they are on a remote git repository) and run the installer.

```bash
# Assuming your dotfiles are ready in /mnt/home/0xjb/.dotfiles
nixos-install --flake /mnt/home/0xjb/.dotfiles#myhost
```

Reboot when finished. Your system will now boot into a fully symmetrical Btrfs RAID0 setup with full hibernation support and dual bootloader redundancy!