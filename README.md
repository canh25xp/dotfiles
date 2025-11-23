# Michael's [dotfiles](https://github.com/canh25xp/dotfiles)

> Manage with `chezmoi` ([github](https://github.com/twpayne/chezmoi) | [documentation](https://www.chezmoi.io/))

![Screenshot](./Pictures/Screenshots/Screenshot-2025-11-16.png)

My Windows, Linux (via WSL) and Android (via [Termux](https://github.com/termux/termux-app)) setup.
Focus on:

- **Consistency**: The experience should be as close as possible, whether I'm on linux or windows, work or home, vscode or neovim.
  Especially the UX (keybindings, commands, aliases, ...), the UI (colorscheme and themes) doesn't have to be.
  A list of [keybindings](./Keybindings.md) is define to ensure this.
- **Minimalism**: Try not to stray too far from the default, especially on the work machine.
  Prioritize app that can easily be install with the OS's default package manager (`winget` for Windows, `apt` for Ubuntu and `pkg` for Termux)
- **Stability**: Minimize breaking changes between update and between machines.
  Don't assume the machine has the require application or net work connection.

Tested on **Windows 11**, **Debian Sid**, **Ubuntu Noble** and **Termux** (without chroot)

## Installation

### Debian & Ubuntu

```bash
sudo apt install git curl
curl -Lo chezmoi_linux_amd64.deb https://github.com/twpayne/chezmoi/releases/download/v2.67.0/chezmoi_2.67.0_linux_amd64.deb
sudo dpkg -i chezmoi_linux_amd64.deb
rm chezmoi_linux_amd64.deb
```

Or using `snap`:

```bash
sudo apt install snapd
sudo snap install chezmoi --classic
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

### Decrypt age key (optional)

```bash
chezmoi age decrypt -p -o ~/.config/chezmoi/key.txt ~/.local/share/chezmoi/.key.txt.age
```

### Login to `gh`

```bash
gh auth login
```

### Build `bat` theme

```bash
bat cache --build
```

### Install `node`

```bash
nvm install latest
nvm use latest
```

### Install Microsoft Font

```bash
echo "deb http://deb.debian.org/debian bookworm contrib non-free" > /etc/apt/sources.list.d/contrib.list
sudo apt install ttf-mscorefonts-installer
fc-list | grep "Times_New_Roman"
```

### Install mingw64 packages

<!-- TODO: automate this process -->

First open mingw64 shell: `C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64`
(Either ucrt64 or mingw64)

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc
pacman -S mingw-w64-ucrt-x86_64-tree-sitter
pacman -S mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-neocmakelsp
pacman -S mingw-w64-ucrt-x86_64-ninja
```

Or install all

```bash
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
```

Add `C:/msys64/mingw64/bin` to your PATH environment variable

## Troubleshooting

### Git command returns fatal error: "detected dubious ownership"

> https://confluence.atlassian.com/bbkb/git-command-returns-fatal-error-about-the-repository-being-owned-by-someone-else-1167744132.html

```bash
git config --global --add safe.directory '*'
```

### Cannot set `LC_CTYPE` to default locale: No such file or directory

> https://askubuntu.com/questions/599808/cannot-set-lc-ctype-to-default-locale-no-such-file-or-directory

```bash
sudo dpkg-reconfigure locales
# Select the following number
97
3
```

### To clear the state of run*onchange* scripts, run:

```bash
chezmoi state delete-bucket --bucket=entryState
```

### To clear the state of run*once* scripts, run:

```bash
chezmoi state delete-bucket --bucket=scriptState
```

### Encrypt files with [age](https://www.chezmoi.io/user-guide/encryption/age/) or [gpg](https://www.chezmoi.io/user-guide/encryption/gpg/)

> [Encryption](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/)

### To change age passphrase

> [!WARNING]
> Might as well just create a new keys and re-encrypt every (encrypted) files

```bash
chezmoi age encrypt -p -o ~/.local/share/chezmoi/.key.txt.age ~/.config/chezmoi/key.txt
```

### To update external dependencies only

```bash
chezmoi apply --include externals -R
```
