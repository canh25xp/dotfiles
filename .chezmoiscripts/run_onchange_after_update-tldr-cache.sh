#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Updating tldr cache"

read -p "Update tldr cache? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! command -v tldr &>/dev/null ; then
	echo "tldr is not installed. Exiting"
	exit 0
fi

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Canceled."
	exit 0
fi

tldr --update
