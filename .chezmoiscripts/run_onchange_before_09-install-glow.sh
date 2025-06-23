#!/bin/bash
# https://github.com/charmbracelet/glow

echo "================================================================================"
echo "[Chezmoi] Installing glow"

if command -v glow &>/dev/null; then
	echo "glow is already installed. Exiting."
	exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

echo "1. Using go install"
echo "2. Using apt install"
echo "3. Quit"

read -p "Enter your choice ([1], 2, 3): " choice

choice="${choice:-1}"

case $choice in
1)
	go install github.com/charmbracelet/glow@latest
	;;
2)
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
	echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
	sudo apt update
	sudo apt install glow
	;;
3)
	exit 0
	;;
*)
  echo "Invalid choice"
  exit 0
  ;;
esac
