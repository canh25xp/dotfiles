#!/bin/bash
# https://github.com/dlvhdr/gh-dash

echo "================================================================================"
echo "[Chezmoi] Installing gh dash extension"

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

gh extension install dlvhdr/gh-dash
