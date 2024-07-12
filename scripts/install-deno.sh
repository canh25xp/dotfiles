#!/bin/bash
# https://deno.com/

echo "================================================================================"
echo "[Chezmoi] Installing deno"

if command -v deno &>/dev/null; then
	echo "deno is already installed. Exiting."
	exit 0
fi

curl -fsSL https://deno.land/install.sh | bash
