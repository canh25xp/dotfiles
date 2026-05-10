# Install systemd unit using `podman quadlet`

Due to unable to disable systemd unit managed by `quadlet quadlet`:

```sh
systemctl --user disable ollama.service
# ollama still start up on next boot
```

Remove have to resolve to manually install individual quadlet

Remove all units:

```sh
podman quadlet rm --all
```

Install desire unit:

```sh
podman quadlet install $(chezmoi source-path $HOME/.config/containers/systemd/ollama.container)
```
