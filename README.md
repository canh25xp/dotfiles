# My [dotfiles](https://github.com/canh25xp/dotfiles), manage with [chezmoi](https://github.com/twpayne/chezmoi)

> [Documentation](https://www.chezmoi.io/)

My Windows, Linux (via WSL) and Android (via [Termux](https://github.com/termux/termux-app)) setup.
Focus on:

- Consistency: The experience should be as close as possible, whether I'm on linux or windows, work or home, vscode or neovim.
  Especially the UX (keybindings, commands, aliases, ...), the UI (colorscheme and themes) doesn't have to be.
- Minimalism: Try not to stray too far from the default, especially on the work machine.
  Prioritize app that can easily be install with the OS's default package manager (`winget` for Windows, `apt` for Ubuntu and `pkg` for Termux)
- Stability: Minimize breaking changes between update and between machines.
  Don't assume the machine has the require application or net work connection.

Tested on **Windows 11**, **Debian Sid**, **Ubuntu Noble** and **Termux** (without chroot)

## Installation

### Debian & Ubuntu

```sh
sudo apt install git curl
curl -LO https://github.com/twpayne/chezmoi/releases/download/v2.63.0/chezmoi_2.63.0_linux_amd64.deb
dpkg -i chezmoi_2.62.0_linux_amd64.deb
rm chezmoi_2.62.0_linux_amd64.deb
```

or using **snap**:

```sh
sudo apt install snapd
sudo snap install chezmoi --classic
```

### Windows

```pwsh
winget install chezmoi
```

### Termux (android)

```sh
pkg install chezmoi
```

### One-line installer

```sh
sudo apt install curl
sh -c "$(curl -fsLS get.chezmoi.io)"
```

## Post installation

### Init dotfiles

```sh
GIT_LFS_SKIP_SMUDGE=1 chezmoi init canh25xp --depth 1
```

### Decrypt age key

```sh
chezmoi age decrypt -p -o ~/.config/chezmoi/key.txt ~/.local/share/chezmoi/key.txt.age
```

### Chage age passphrase

```sh
chezmoi age encrypt -p -o ~/.local/share/chezmoi/key.txt.age ~/.config/chezmoi/key.txt  
```

### Login to gh

```sh
gh auth login
```

### Build Bat theme

```sh
bat cache --build
```

### Install node

```sh
nvm install latest
nvm use latest
node --version
npm --version
```

### Install Microsoft Fonts

```sh
echo "deb http://deb.debian.org/debian bookworm contrib non-free" > /etc/apt/sources.list.d/contrib.list
sudo apt install ttf-mscorefonts-installer
fc-list | grep "Times_New_Roman"
```

### Install mingw64 packges

<!-- TODO: automate this process -->
First open mingw64 shell: `C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64`
(Either ucrt64 or mingw64)

```sh
pacman -S mingw-w64-ucrt-x86_64-gcc
pacman -S mingw-w64-ucrt-x86_64-tree-sitter
pacman -S mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-neocmakelsp
pacman -S mingw-w64-ucrt-x86_64-ninja
```

Or install all

```sh
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
```

Add `C:/msys64/mingw64/bin` to your PATH environment variable

## Troubleshooting

### Git command returns fatal error: "detected dubious ownership"

> https://confluence.atlassian.com/bbkb/git-command-returns-fatal-error-about-the-repository-being-owned-by-someone-else-1167744132.html

```sh
git config --global --add safe.directory '*'
```

### Cannot set LC_CTYPE to default locale: No such file or directory

> https://askubuntu.com/questions/599808/cannot-set-lc-ctype-to-default-locale-no-such-file-or-directory

```sh
sudo dpkg-reconfigure locales

97

3
```

## FAQ

### Add new user

To create new user with password and sudo privilege then change default shell to bash:

```sh
apt update && apt upgrade && apt install sudo
useradd -m username
passwd username
usermod -aG sudo username
usermod --shell /bin/bash username
su - username
```

A simpler way:

```sh
apt update && apt upgrade && apt install adduser sudo
adduser username
usermod -aG sudo username
su - username
```

### WSL set default user

```sh
echo -e "[user]\ndefault=user" | sudo tee /etc/wsl.conf > /dev/null
```

### To clear the state of run*onchange* scripts, run:

```sh
chezmoi state delete-bucket --bucket=entryState
```

### To clear the state of run*once* scripts, run:

```sh
chezmoi state delete-bucket --bucket=scriptState
```

### Mermaid-cli error

```
Generating single mermaid chart

Error: Failed to launch the browser process!
/home/michael/.cache/puppeteer/chrome-headless-shell/linux-131.0.6778.204/chrome-headless-shell-linux64/chrome-headless-
shell: error while loading shared libraries: libasound.so.2: cannot open shared object file: No such file or directory
```

```sh
sudo apt -y install libasound2t64 # provide libasound2
```

### SSH

on the local machine:

```sh
git remote add ssh ssh://u0_a353@localhost:8022/~/.local/share/chezmoi
```

on the ssh:

```sh
git config receive.denyCurrentBranch updateInstead
```

### Perforce

> https://help.perforce.com/helix-core/extras/packages/perforce-packages.html
