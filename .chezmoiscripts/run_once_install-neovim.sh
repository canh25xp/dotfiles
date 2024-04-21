#!/bin/bash

# https://github.com/neovim/neovim/blob/master/BUILD.md

echo "Installing neovim ..."

if command -v nvim &>/dev/null; then
	echo "Neovim is already installed. Exiting."
	exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
fi

mkdir -p ~/projects/lua/

git clone --depth 1 https://github.com/neovim/neovim ~/projects/lua/neovim

cd neovim

sudo apt-get update

sudo apt-get install ninja-build gettext cmake unzip curl build-essential file

make CMAKE_BUILD_TYPE=RelWithDebInfo

cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
