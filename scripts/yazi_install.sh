#!/usr/bin/env bash

set -e

# Define variables
VERSION="v25.3.2"
ZIP_URL="https://github.com/sxyazi/yazi/releases/download/${VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
TMP_DIR="$(mktemp -d)"
INSTALL_DIR="/usr/local/bin"
COMPLETION_DIR="$HOME/.local/share/bash-completion/completions"

echo "🔽 Downloading Yazi ${VERSION}..."
curl -L "$ZIP_URL" -o "$TMP_DIR/yazi.zip"

echo "📦 Extracting..."
unzip -q "$TMP_DIR/yazi.zip" -d "$TMP_DIR"

echo "🚀 Installing yazi and ya to $INSTALL_DIR..."
sudo install "$TMP_DIR/yazi" "$INSTALL_DIR/yazi"
sudo install "$TMP_DIR/ya" "$INSTALL_DIR/ya"

echo "✅ Installed yazi and ya."

# Setup completion
echo "🔧 Setting up Bash completions..."
mkdir -p "$COMPLETION_DIR"
cp -v "$TMP_DIR/completions/yazi.bash" "$COMPLETION_DIR/yazi"
cp -v "$TMP_DIR/completions/ya.bash" "$COMPLETION_DIR/ya"

echo "📌 To enable completions, add this to your ~/.bashrc if not already present:"
echo '[[ -r ~/.local/share/bash-completion/completions/yazi ]] && source ~/.local/share/bash-completion/completions/yazi'
echo '[[ -r ~/.local/share/bash-completion/completions/ya ]] && source ~/.local/share/bash-completion/completions/ya'

echo "🧹 Cleaning up..."
rm -rf "$TMP_DIR"

echo "✅ Done! You can now run 'yazi' and 'ya'"
