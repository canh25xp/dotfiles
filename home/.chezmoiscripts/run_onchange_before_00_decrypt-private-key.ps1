if (-not (Test-Path $HOME/.config/chezmoi/key.txt)) {
    chezmoi age decrypt --passphrase --output $HOME/.config/chezmoi/key.txt $HOME/.local/share/chezmoi/.key.txt.age
}
