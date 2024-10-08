#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing base apt packages"

packages=(
	git
	gh
	curl
	wget
	man-db
	unzip
	zip
	xclip
	bash-completion
	build-essential
	python3
	python3-pip
	python3-venv
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

# Install packages
sudo apt-get update
sudo apt-get install "${packages[@]}"
