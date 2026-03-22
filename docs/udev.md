# `udev` device management

## QMK udev rules

```sh
sudoedit /etc/udev/rules.d/50-qmk.rules
```

```
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
```

```sh
sudo udevadm control --reload-rules && sudo udevadm trigger
```
