#!/bin/bash
# https://github.com/gokcehan/lf

echo "================================================================================"
echo "[Chezmoi] Installing lf"

if command -v lf &>/dev/null; then
	echo "lf is already installed. Exiting."
	exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
