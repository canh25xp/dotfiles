#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing apt packages"

read -p "Continue? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" =~ ^[Yy]$ ]]; then
  echo "Canceled"
  exit 0
fi

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
  lazygit
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

sudo apt-get update

available_packages=()
missing_packages=()

for pkg in "${selected_packages[@]}"; do
  if apt-cache show "$pkg" >/dev/null 2>&1; then
    available_packages+=("$pkg")
  else
    missing_packages+=("$pkg")
  fi
done

# Show results
if (( ${#missing_packages[@]} > 0 )); then
  echo
  echo "Warning: The following packages were not found and will be skipped:"
  for pkg in "${missing_packages[@]}"; do
    echo " - $pkg"
  done
fi

if (( ${#available_packages[@]} == 0 )); then
  echo
  echo "No valid packages to install. Exiting."
  exit 1
fi

echo
echo "The following packages will be installed:"
for pkg in "${available_packages[@]}"; do
  echo " - $pkg"
done

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" =~ ^[Yy]$ ]]; then
  echo "Installation canceled."
  exit 0
fi

sudo apt-get install "${available_packages[@]}" -y
