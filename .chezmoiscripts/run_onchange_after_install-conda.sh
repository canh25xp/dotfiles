#!/bin/bash
# https://docs.anaconda.com/free/miniconda/

echo "================================================================================"
echo "[Chezmoi] Installing conda (miniconda)"

if command -v conda &>/dev/null; then
    echo "conda is already installed. Exiting."
    exit 0
fi

read -p "Do you want to proceed with the installation? (Y/n): " confirmation
confirmation=${confirmation:-Y}

if ! [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
    echo "Installation canceled."
    exit 0
fi

mkdir -p ~/miniconda3

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

rm -rf ~/miniconda3/miniconda.sh

