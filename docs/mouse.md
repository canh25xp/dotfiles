# Mouse

This document captures the steps I use on Debian to tame my Logitech G304 pointer:

## Disable mouse acceleration and lower pointer speed

### One-off testing

Use `xinput` to list devices and apply a temporary speed adjustment so you can tune before committing it to X11 config:

```sh
xinput
# locate the Logitech G304 ID (14 in my case) then run:
xinput set-prop 14 "libinput Accel Speed" -0.5
```

This change lasts until the next X11 restart.

### Persistent settings

Create `/etc/X11/xorg.conf.d/50-mouse.conf` and lock in the profile and speed I like:

```sh
sudoedit /etc/X11/xorg.conf.d/50-mouse.conf
```

```
Section "InputClass"
    Identifier "Logitech G304"
    MatchProduct "Logitech G304"
    Driver "libinput"
    Option "AccelProfile" "flat"
    Option "AccelSpeed" "-0.5"
EndSection
```

Adjust `AccelSpeed` between -1 and 1 if you want faster/slower behavior; `flat` profile keeps the pointer speed linear.
