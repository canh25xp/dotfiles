# https://www.rust-lang.org/tools/install

echo "================================================================================"
echo "[Chezmoi] Installing cargo"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install git-delta
cargo install eza
cargo install tree-sitter
