#!/bin/bash

echo "================================================================================"
echo "[Chezmoi] Installing utils apt packages"

packages=(
	# vim
	# neovim
	neofetch
	ripgrep
	fd-find
	bat
	htop
	zathura
	lf
	zoxide
	fzf
	hexyl
	gdu
	tmux
	neomutt
	pass
	speedtest-cli
	qrencode
	nsxiv
	luarocks
	gdb
	lolcat
	eza
	git-delta
	tealdeer
  tree-sitter-cli
)

echo "The following packages will be installed:"
for package in "${packages[@]}"; do
	echo "- $package"
done

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}
if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Installation canceled."
	exit 0
fi

# Install packages
sudo apt-get update
sudo apt-get install "${packages[@]}"

read -p "Symlink bat and fd? (Y/n): " confirmation_symlink
confirmation_symlink=${confirmation_symlink:-Y}

if [[ "$confirmation_symlink" == "y" || "$confirmation_symlink" == "Y" ]]; then
	mkdir -p ~/.local/bin
	ln -s $(which fdfind) ~/.local/bin/fd
	ln -s $(which batcat) ~/.local/bin/bat
fi
