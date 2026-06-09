#!/usr/bin/env pwsh

# TTY detection: skip interactive operations if no TTY
# In PowerShell, check if stdin is redirected
$IsInteractive = -not [Console]::IsInputRedirected

$keyFile = "$HOME/.config/chezmoi/key.txt"
$encFile = "$HOME/.local/share/chezmoi/.key.txt.age"

if (-not (Test-Path $keyFile)) {
    # Skip decrypt if not interactive (non-interactive mode)
    if (-not $IsInteractive) {
        Write-Host "[Chezmoi] No TTY detected, skipping key decryption"
        exit 0
    }

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
