# Installing NVIDIA Drivers on Debian

## Step 1: Detect Your Hardware

First, verify your NVIDIA GPU is detected:

```bash
lspci | grep -i nvidia
```

Expected output example:

```
01:00.0 VGA compatible controller: NVIDIA Corporation GA102 [GeForce RTX 3080 Ti] (rev a1)
```

## Step 2: Enable Non-Free Repositories

Edit `/etc/apt/sources.list`:

```bash
sudo nvim /etc/apt/sources.list
```

Add `non-free contrib non-free-firmware` to each repository line, or at least for the base (bookworm, trxie, fortky etc)

```
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security/ trixie-security contrib non-free main non-free-firmware
deb http://deb.debian.org/debian/ trixie-updates non-free-firmware non-free contrib main
```

Update package lists:

```bash
sudo apt update
```

## Step 3: Install kernel headers

```bash

apt install linux-headers-$(uname -r)
# or
apt install linux-headers-generic
```

## Step 4: Install drivers

Install the `nvidia-driver` metapackage, which provides the latest stable driver:

```bash
sudo apt install nvidia-kernel-dkms nvidia-driver
```

## Step 5: Install Development Packages (Optional)

For CUDA development or building kernel modules:

```bash
sudo apt install -y nvidia-cuda-dev nvidia-cuda-toolkit
```

## Step 6: Reboot

```bash
sudo reboot
```

## Step 7: Verify Installation

```bash
nvidia-smi
```

Expected output includes:

```
Mon Mar 16 21:58:53 2026
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 550.163.01             Driver Version: 550.163.01     CUDA Version: 12.4     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3080 Ti     Off |   00000000:01:00.0  On |                  N/A |
|  0%   41C    P8             31W /  400W |     416MiB /  12288MiB |      7%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A      2522      G   /usr/lib/xorg/Xorg                            210MiB |
|    0   N/A  N/A      2589      G   x-terminal-emulator                            42MiB |
|    0   N/A  N/A      2993      G   ...cess-track-uuid=3190708988185955192        152MiB |
+-----------------------------------------------------------------------------------------+
```

## Troubleshoot

### Failed to load driver

```console
$ lsmod | grep nvidia

$ uname -r
6.12.74+deb13+1-amd64

$ sudo dkms status
nvidia-current/550.163.01, 6.12.73+deb13-amd64, x86_64: installed
```

Reason: Kernel version mismatch

Solution: rebuild driver for current kernel

```sh
sudo apt install linux-headers-$(uname -r)
sudo dkms autoinstall
sudo update-initramfs -u
```

## References

- [NVIDIA Official Driver Installation Guide](https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/debian.html)
- [Debian Wiki: NVIDIA Graphics Drivers](https://wiki.debian.org/NvidiaGraphicsDrivers)
