#!/data/data/com.termux/files/usr/bin/bash

echo "================================================================================"
echo "[Chezmoi] termux install base packages"

packages=(
  termux-api
  git
  gh
  curl
  wget
  man
  unzip
  p7zip
  zip
  openssh
  bash-completion
  build-essential
  python
  python-pip
  nodejs
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
