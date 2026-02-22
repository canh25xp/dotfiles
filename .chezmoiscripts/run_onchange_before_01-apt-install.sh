#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing apt packages"

read -p "Continue? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" =~ ^[Yy]$ ]]; then
  echo "Canceled"
  exit 0
fi

default_packages=(
  adb
  alsa-utils pipewire pipewire-audio wireplumber # For audio
  bash-completion
  bat
  bluez # For bluetooth
  btm
  build-essential
  curl
  direnv
  duf
  entr
  eza
  fastfetch
  fd-find
  feh  # Display Background for `i3`
  fzf
  gawk # required for `trans`
  gdb
  gdu
  gh
  git
  git-delta
  git-lfs
  golang
  hexyl
  htop
  httpie
  i3
  jq
  kitty
  lazygit
  libsqlite3-dev # required for bookmarks.nvim
  lolcat
  luarocks
  man-db
  neomutt
  neovim
  netcat-traditional
  network-manager wpasupplicant iproute2 ifupdown iw # For Wi-Fi
  nodejs
  npm
  nsxiv
  p4
  p7zip
  pass
  procs
  python3
  python3-pip
  python3-venv
  qrencode
  ripgrep
  rsync
  rustup
  sd
  speedtest-cli
  sqlite3 # required for bookmarks.nvim
  starship
  steghide
  tealdeer
  tmux
  trash-cli
  tree-sitter-cli
  unzip
  wget
  xclip
  xorg
  zathura
  zip
  zoxide
)

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

printf "%s\n" "${default_packages[@]}" >"$temp_file"

if command -v nvim >/dev/null; then
  editor="nvim"
elif command -v vim >/dev/null; then
  editor="vim"
elif command -v nano >/dev/null; then
  editor="nano"
else
  echo "No suitable editor found (nvim, vim, or nano). Aborting."
  exit 1
fi

echo
echo "Opening package list for editing. Remove any lines for packages you don't want to install."
$editor "$temp_file"

# Read edited package list
mapfile -t selected_packages <"$temp_file"

# Skip empty or comment lines
selected_packages=("${selected_packages[@]/*#/}")
selected_packages=("${selected_packages[@]/#/}") # Trim whitespace

# Remove empty entries
selected_packages=($(printf "%s\n" "${selected_packages[@]}" | sed '/^\s*$/d'))

if [[ ${#selected_packages[@]} -eq 0 ]]; then
  echo "No packages selected. Exiting."
  exit 1
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

# Show missing packages
if ((${#missing_packages[@]} > 0)); then
  echo
  echo "Warning: The following packages were not found and will be skipped:"
  for pkg in "${missing_packages[@]}"; do
    echo " - $pkg"
  done
fi

if ((${#available_packages[@]} == 0)); then
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
