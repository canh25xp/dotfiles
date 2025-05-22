# My [dotfiles](https://github.com/canh25xp/dotfiles), manage with [chezmoi](https://github.com/twpayne/chezmoi)

> [Documentation](https://www.chezmoi.io/)

## Installation

### Debian & Ubuntu

```sh
sudo apt install git curl
curl -LO https://github.com/twpayne/chezmoi/releases/v2.62.0/latest/chezmoi_2.62.0_linux_amd64.deb
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

### Install tree-sitter

Install visual studio and c++ build tools, open "Developer Powershell for vVsual Studio 2022"

```sh
cargo install tree-sitter-cli
```

### Install TMU packages

`C-a I`

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
