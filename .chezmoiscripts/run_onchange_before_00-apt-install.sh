#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing apt packages"

packages=(
  bash-completion
  bat
  btm
  build-essential
  curl
  eza
  fd-find
  fzf
  gdb
  gdu
  gh
  git
  git-delta
  git-lfs
  golang
  hexyl
  htop
  lolcat
  luarocks
  man-db
  neomutt
  neovim
  nodejs
  npm
  nsxiv
  p7zip
  pass
  python3
  python3-pip
  python3-venv
  qrencode
  ripgrep
  rustup
  speedtest-cli
  starship
  tealdeer
  tmux
  tree-sitter-cli
  unzip
  wget
  xclip
  zathura
  zip
  zoxide
)

# Let user choose which packages to install
echo "Select packages to install (enter numbers separated by spaces):"
for i in "${!packages[@]}"; do
  printf "%2d) %s\n" "$((i+1))" "${packages[i]}"
done

read -p "Your choices [default: all]: " input

if [[ -z "$input" ]]; then
  selected_packages=("${packages[@]}")
else
  selected_packages=()
  for index in $input; do
    if [[ "$index" =~ ^[0-9]+$ ]] && (( index >= 1 && index <= ${#packages[@]} )); then
      selected_packages+=("${packages[index-1]}")
    else
      echo "Invalid selection: $index"
      exit 1
    fi
  done
fi

echo
echo "The following packages will be installed:"
for package in "${selected_packages[@]}"; do
  echo "- $package"
done

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
  echo "Installation canceled."
  exit 0
fi

sudo apt-get install "${selected_packages[@]}" -y

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
