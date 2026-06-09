# Miscellaneous

## FAQ

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

First install locales package with `sudo apt instlal locale`.
Then:

```bash
sudo dpkg-reconfigure locales
# Select the following number
97
3
```

Or non-interatively:

```bash
sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=en_US.UTF-8
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

### Enable sign commits

```bash
# whole project
git config commit.gpgsign true
# per commit
git commit -S
# check signature last commit
git log -1 --show-signature
```
