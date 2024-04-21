#!/bin/bash

# https://github.com/neovim/neovim/blob/master/BUILD.md

echo "Installing neovim ..."

if command -v nvim &>/dev/null; then
    echo "Neovim is already installed. Exiting."
    exit 0
fi

mkdir -p ~/projects/lua/

git clone --depth 1 https://github.com/neovim/neovim ~/projects/lua/neovim

cd neovim

sudo apt-get update

sudo apt-get install ninja-build gettext cmake unzip curl build-essential file

make CMAKE_BUILD_TYPE=RelWithDebInfo

cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
