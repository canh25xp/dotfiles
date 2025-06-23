#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing base apt packages"

packages=(
  bash-completion
  build-essential
  curl
  gh
  git
  man-db
  nodejs
  npm
  p7zip
  python3
  python3-pip
  python3-venv
  unzip
  wget
  xclip
  zip
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
