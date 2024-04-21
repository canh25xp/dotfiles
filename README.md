# My [dotfiles](https://github.com/canh25xp/dotfiles), manage with [chezmoi](https://github.com/canh25xp/dotfiles)
> [Documentation](https://www.chezmoi.io/)

## Installation

### Install chezmoi

#### Using snap (linux)
```bash
sudo apt install snapd
sudo snap install chezmoi --classic
```

#### Using winget (windows)
```pwsh
winget install chezmoi
```

#### Using curl
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Init dotfiles

```
chezmoi init canh25xp
```

## Post install

### Required packages

1. [git](https://github.com/git/git) : `sudo apt install git`

2. [gh](https://github.com/cli/cli) : `sudo apt install gh`
- Optional : install [gh-dash](https://github.com/dlvhdr/gh-dash) : `gh extension install dlvhdr/gh-dash`
- login : `gh auth login`

### Create Newuser

```sh
# As root:
useradd -m <username>
passwd <username>
usermod -a -G sudo <username>
su - <username>
chsh -s /bin/bash
```

### Build Bat theme

```
bat cache --build
```

## Troubleshooting

### Git command returns fatal error: "detected dubious ownership"
> https://confluence.atlassian.com/bbkb/git-command-returns-fatal-error-about-the-repository-being-owned-by-someone-else-1167744132.html

```
git config --global --add safe.directory '*'
```

