# My [dotfiles](https://github.com/canh25xp/dotfiles), manage with [chezmoi](https://github.com/twpayne/chezmoi)

> [Documentation](https://www.chezmoi.io/)

## Installation

### Install chezmoi

#### Using snap (linux)

```sh
sudo apt install snapd
sudo snap install chezmoi --classic
```

#### Using winget (windows)

```pwsh
winget install chezmoi
```

#### Using curl

```sh
apt install curl
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Init dotfiles

```sh
chezmoi init canh25xp
```

## Post install

### Login to gh

```sh
gh auth login
```

### Create Newuser

```sh
useradd -m <username>
passwd <username>
usermod -aG sudo <username>
su - <username>
chsh -s /bin/bash
```

a simpler way :

```sh
# As root:
apt install adduser sudo
sudo adduser username
sudo usermod -aG sudo username
su - username
```

### Build Bat theme

```sh
bat cache --build
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

### To clear the state of run*onchange* scripts, run:

```sh
chezmoi state delete-bucket --bucket=entryState
```

### To clear the state of run*once* scripts, run:

```sh
chezmoi state delete-bucket --bucket=scriptState
```
