#!/bin/sh

packages=(
	"curl"
	"wget"
	"wslu"
	"vim"
	"neofetch"
	"git"
	"snapd"
	"man-db"
	"bash-completion"
	"ripgrep"
	"unzip"
	"python3"
	"python3-pip"
	"build-essential"
  "python3-venv"
)

echo "The following packages will be installed:"
for package in "${packages[@]}"; do
	echo "- $package"
done

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	# Install packages
	sudo apt-get update
	sudo apt-get install "${packages[@]}"
	echo "Packages installed successfully!"
else
	echo "Installation canceled."
fi
