#!/data/data/com.termux/files/usr/bin/bash

echo "================================================================================"
echo "[Chezmoi] termux install base packages"

packages=(
  bash-completion
  bat
  build-essential
  curl
  entr
  eza
  fastfetch
  fd
  fzf
  gdb
  gdu
  gh
  git
  git-delta
  git-lfs
  glow
  hexyl
  htop
  lazygit
  luarocks
  man
  neomutt
  neovim
  nodejs
  openssh
  p7zip
  pass
  python
  python-pip
  ripgrep
  starship
  taplo
  tealdeer
  termux-api
  tmux
  tree-sitter
  unzip
  wget
  yazi
  zip
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

pkg upgrade
pkg install "${packages[@]}"
