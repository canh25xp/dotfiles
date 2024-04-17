# My [dotfiles](https://github.com/canh25xp/dotfiles), manage with [chezmoi](https://github.com/canh25xp/dotfiles)
> [Documentation](https://www.chezmoi.io/)

## Installation
### Install chezmoi

```bash
sudo apt install snapd
sudo snap install chezmoi --classic
```

```pwsh
winget install chezmoi
```

### Init dotfiles
```
chezmoi init canh25xp
```

## Post install
Git command returns fatal error: "detected dubious ownership"
> https://confluence.atlassian.com/bbkb/git-command-returns-fatal-error-about-the-repository-being-owned-by-someone-else-1167744132.html
```
git config --global --add safe.directory '*'
```

### Required packages
1. [Git](https://github.com/git/git)
