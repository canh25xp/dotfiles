# OpenRGB on Debian

## Install

```bash
wget https://codeberg.org/OpenRGB/OpenRGB/releases/download/release_candidate_1.0rc2/openrgb_1.0rc2_amd64_trixie_0fca93e.deb
sudo apt install -y ./openrgb_1.0rc2_amd64_trixie_0fca93e.deb
```

## Enable SMBus access

Add your user to `i2c` group:

```bash
sudo usermod -aG i2c "$USER"
```

Load kernel module now:

```bash
sudo modprobe i2c-dev
sudo modprobe i2c-i801
```

Load it automatically on boot:

```bash
echo i2c-dev | sudo tee /etc/modules-load.d/openrgb.conf
echo i2c-i801 | sudo tee /etc/modules-load.d/openrgb.conf
```
