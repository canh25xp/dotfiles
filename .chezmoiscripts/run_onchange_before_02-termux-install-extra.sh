#!/data/data/com.termux/files/usr/bin/bash

echo "================================================================================"
echo "[Chezmoi] termux install extra packages"

packages=(
  neovim
  ripgrep
  fd
  bat
  htop
  zoxide
  fzf
  hexyl
  gdu
  tmux
  neomutt
  pass
  luarocks
  gdb
  eza
  yazi
  glow
  git-delta
  tealdeer
  tree-sitter
  git-lfs
  lazygit
  starship
  taplo
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

pkg install "${packages[@]}"
