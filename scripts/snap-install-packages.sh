#!/bin/sh

packages=(
  "chezmoi"
  "nvim"
  "tldr"
  "glow"
  "rustup"
)

echo "The following packages will be installed:"
for package in "${packages[@]}"; do
	echo "- $package"
done

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	# Install packages
	sudo snap install "${packages[@]}"
	echo "Packages installed successfully!"
else
	echo "Installation canceled."
fi

