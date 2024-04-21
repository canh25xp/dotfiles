#!/bin/bash
#https://github.com/nvm-sh/nvm

echo "Installing nvm"

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

nvm install node
