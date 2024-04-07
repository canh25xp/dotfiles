#!/bin/sh

# Read packages from apt_packages.txt
mapfile -t packages < apt_packages.txt

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
