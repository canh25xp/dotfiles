# Michael's [dotfiles](https://github.com/canh25xp/dotfiles)

> Manage with `chezmoi` ([github](https://github.com/twpayne/chezmoi) | [documentation](https://www.chezmoi.io/))

![Screenshot](./assets/Screenshot-2025-11-16.png)

My Windows, Linux (via WSL) and Android (via [Termux](https://github.com/termux/termux-app)) setup.
Focus on:

- **Consistency**: The experience should be as close as possible, whether I'm on linux or windows, work or home, vscode or neovim.
  Especially the UX (keybindings, commands, aliases, ...), the UI (colorscheme and themes) doesn't have to be.
  A list of [keybindings](./docs/keybindings.md) is define to ensure this.
- **Minimalism**: Try not to stray too far from the default, especially on the work machine.
  Prioritize app that can easily be install with the OS's default package manager (`winget` for Windows, `apt` for Ubuntu and `pkg` for Termux)
- **Stability**: Minimize breaking changes between update and between machines.
  Don't assume the machine has the require application or net work connection.

Tested on **Windows 11**, **Debian Sid**, **Ubuntu Noble** and **Termux** (without chroot)

## Quick test

```sh
docker run -it --rm ghcr.io/canh25xp/dotfiles-debian:latest
```

Or using WSL:

```pwsh
curl -LO https://github.com/canh25xp/dotfiles/releases/latest/download/dotfiles-debian.tar.gz
wsl --import Debian C:\WSL\Debian dotfiles-debian.tar.gz --version 2
wsl -d Debian -u canh25xp --cd ~
```

## Installation

### Debian & Ubuntu

```bash
sudo apt install git curl
curl -fsSL https://api.github.com/repos/twpayne/chezmoi/releases/latest | grep -o 'https://[^"]*linux_amd64\.deb' | xargs -n1 curl -Lo chezmoi_linux_amd64.deb
sudo dpkg -i chezmoi_linux_amd64.deb
rm chezmoi_linux_amd64.deb
```

### Windows

```pwsh
winget install chezmoi
```

### Termux

```bash
pkg install chezmoi
```

### One-line installer (any platform)

```bash
sudo apt install curl
sh -c "$(curl -fsLS get.chezmoi.io)"
```

## Post installation

### Init dotfiles

```bash
chezmoi init canh25xp
```

Add `GIT_LFS_SKIP_SMUDGE` if you want skip download `git-lfs` files (mostly my wallpapers) and specify `--depth` to shallow clone only.

```bash
GIT_LFS_SKIP_SMUDGE=1 chezmoi init canh25xp --depth 1
```

### Apply

```bash
chemzoi apply
```

## Dockerize

```sh
docker build -t dotfiles-debian .
docker run -it --rm dotfiles-debian
```

Build minimal tag.
The default tag is "full"

```sh
docker build -t dotfiles-debian:minimal . --target minimal
docker run -it --rm dotfiles-debian:minimal
```

Run with persistent user home data.

```sh
docker run -it --rm -v dotfiles-home:/home/canh25xp dotfiles-debian
```
