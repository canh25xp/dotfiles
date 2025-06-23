#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing extra apt packages"

packages=(
  bat
  btm
  eza
  fd-find
  fzf
  gdb
  gdu
  git-delta
  git-lfs
  golang
  hexyl
  htop
  lolcat
  luarocks
  neomutt
  neovim
  nsxiv
  pass
  qrencode
  ripgrep
  rustup
  speedtest-cli
  starship
  tealdeer
  tmux
  tree-sitter-cli
  zathura
  zoxide
)

echo "The following packages will be installed:"
for package in "${packages[@]}"; do
  echo "- $package"
done

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
  echo "Installation canceled."
  exit 0
fi

sudo apt-get install "${packages[@]}" -y

mkdir -p ~/.local/bin/

if ! command -v fd &> /dev/null; then
  if command -v fdfind &>/dev/null; then
    echo "Creating symlinks fdfind -> fd"
    ln -s $(which fdfind) ~/.local/bin/fd
  fi
fi

if ! command -v bat &> /dev/null; then
  if command -v batcat &>/dev/null; then
    echo "Creating symlinks batcat -> bat"
    ln -s $(which batcat) ~/.local/bin/bat
  fi
fi
