#!/usr/bin/bash

# https://github.com/neovim/neovim/blob/master/BUILD.md

git clone https://github.com/neovim/neovim --depth 1
cd neovim

sudo apt-get update

sudo apt-get install ninja-build gettext cmake unzip curl build-essential file

make CMAKE_BUILD_TYPE=RelWithDebInfo

cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
# Or
# sudo make install
