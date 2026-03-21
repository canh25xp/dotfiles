# USB

## Format

1. Plug in the stick and run `lsblk -f` to confirm the block device name (e.g. `/dev/sda1`).

   ```console
   lsblk
   NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
   sda           8:0    1  57.3G  0 disk
   └─sda1        8:1    1  57.3G  0 part /mnt/usb
   nvme0n1     259:0    0 465.8G  0 disk
   ├─nvme0n1p1 259:1    0    16M  0 part
   ├─nvme0n1p2 259:2    0   465G  0 part
   └─nvme0n1p3 259:3    0   735M  0 part
   nvme1n1     259:4    0 931.5G  0 disk
   ├─nvme1n1p1 259:5    0   976M  0 part /boot/efi
   ├─nvme1n1p2 259:6    0 898.8G  0 part /
   └─nvme1n1p3 259:7    0  31.7G  0 part [SWAP]
   ```

2. If it is mounted, unmount it first:

   ```bash
   sudo umount /dev/sda1
   ```

3. (Optional) Wipe existing metadata to avoid leftover partitions:

   ```bash
   sudo wipefs -a /dev/sda
   sudo fdisk /dev/sda
   > o   # new empty DOS partition table
   > n   # new partition
   > w   # write
   ```

4. Format
   For windows and linux compatible, use exFAT (requires `exfatprogs`), otherwise FAT32 for ~32 GB sticks.
   ```bash
   sudo apt install --no-install-recommends exfatprogs  # skip on Windows/WSL if already installed
   sudo mkfs.exfat -n USB /dev/sda1
   ```

## Mount

Create a mountpoint and mount with your user ID so files are writable without sudo:

```bash
sudo mkdir -p /mnt/usb
sudo mount -o uid=$(id -u),gid=$(id -g),umask=022 /dev/sda1 /mnt/usb
```

## Auto mount

If this USB stick lives in the same slot and should always mount to `/mnt/usb`, note its UUID and add an `/etc/fstab` entry.

```bash
sudo blkid /dev/sda1
# copy the UUID value, then append:
sudo tee -a /etc/fstab <<'FSTAB'
UUID=2CDA-919B  /mnt/usb  exfat  defaults,uid=1000,gid=1000,umask=022  0 0
FSTAB
```
