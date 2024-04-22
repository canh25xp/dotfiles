#!/bin/bash
#https://github.com/nvm-sh/nvm

echo "Installing node"

if command -v node &>/dev/null; then
	echo "node is already installed. Exiting."
	exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

nvm install node
