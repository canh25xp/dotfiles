#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing rustup"

if command -v rustup &>/dev/null; then
	echo "rustup is already installed. Exiting."
	exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

# sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install rustup

rustup default stable
