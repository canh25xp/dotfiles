#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Create symlink"

read -p "Continue? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
  echo "Canceled."
  exit 0
fi

mkdir -p ~/.local/bin/

if ! command -v fd &> /dev/null; then
  if command -v fdfind &>/dev/null; then
    echo "Creating symlinks fdfind -> fd"
    ln -s $(which fdfind) ~/.local/bin/fd
  fi
fi

if ! command -v bat &> /dev/null; then
  if command -v batcat &>/dev/null; then
    echo "Creating symlinks batcat -> bat"
    ln -s $(which batcat) ~/.local/bin/bat
  fi
fi
