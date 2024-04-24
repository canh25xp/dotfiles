#!/bin/bash
#https://github.com/nvm-sh/nvm

echo "================================================================================"
echo "[Chezmoi] Installing cht.sh"

if [ -e "${HOME}/bin/cht.sh" ]; then
	echo "cht.sh is already installed. Exiting."
	exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

PATH_DIR="$HOME/bin"  # or another directory on your $PATH

mkdir -p "$PATH_DIR"

curl https://cht.sh/:cht.sh > "$PATH_DIR/cht.sh"

chmod +x "$PATH_DIR/cht.sh"
