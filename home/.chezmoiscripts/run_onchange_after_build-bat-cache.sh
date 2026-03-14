#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Building bat theme (catppuccin)"

if command -v bat &>/dev/null; then
    BAT_CMD="bat"
elif command -v batcat &>/dev/null; then
    BAT_CMD="batcat"
else
    echo "Neither 'bat' nor 'batcat' is installed. Exiting."
    exit 1
fi

read -p "Build bat theme? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" =~ ^[Yy]$ ]]; then
	echo "Canceled."
	exit 0
fi

"$BAT_CMD" cache --build
