#!/usr/bin/env pwsh

$keyFile = "$HOME/.config/chezmoi/key.txt"
$encFile = "$HOME/.local/share/chezmoi/.key.txt.age"

if (-not (Test-Path $keyFile)) {

    $attempt = 0
    while ($attempt -lt 3) {
    try {
        chezmoi age decrypt --passphrase --output $keyFile $encFile
        if (Test-Path $keyFile) {
            break
        }
    } catch {}

    $attempt++
    Write-Host "Decrypt failed ($attempt/3), try again..."
}

}

# Skip decrypt
exit 0
