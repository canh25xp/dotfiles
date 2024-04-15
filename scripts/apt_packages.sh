#!/bin/sh

script_dir=$(dirname "$0")

mapfile -t packages < "$script_dir/apt_packages.txt"

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

echo "symlink bat and fd"
ln -s $(which fdfind) ~/.local/bin/fd
ln -s $(which batcat) ~/.local/bin/bat

