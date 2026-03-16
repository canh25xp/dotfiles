# Getty autologin

Create an override for the default getty on `tty1` so systemd can pass `--autologin`.

```bash
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
cat <<'EOF' | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-- \\u' --noreset --noclear --autologin michael - ${TERM}
TTYVTDisallocate=no
EOF
```

> [!IMPORTANT]
> Notice the trailing `ExecStart=`, otherwise next boot might fails.
> `TTYVTDisallocate=no` keeps the terminal frame buffer active across logouts.

> [!NOTE]
> Remove `'-- \\u'` will skip password entirely

Reload systemd units and restart the getty service.

```bash
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1.service
```

## Reverting the change

```bash
sudo rm /etc/systemd/system/getty@tty1.service.d/autologin.conf
```
