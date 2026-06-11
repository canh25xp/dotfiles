#!/usr/bin/env pwsh

# --- Helper functions ---

function Test-TTY {
  -not [Console]::IsInputRedirected
}

function Write-Banner {
  param([string]$Message)
  Write-Host "================================================================================"
  Write-Host "[Chezmoi] $Message"
}

# --- Main ---

$KeyFile = "$HOME/.config/chezmoi/key.txt"
$EncFile = "$HOME/.local/share/chezmoi/.key.txt.age"

if (Test-Path $KeyFile) {
  exit 0
}

# Skip decrypt if not interactive (non-interactive mode)
if (-not (Test-TTY)) {
  Write-Host "[Chezmoi] No TTY detected, skipping key decryption"
  exit 0
}

Write-Banner "decrypt private key"

$attempt = 0
while ($attempt -lt 3) {
  try {
    chezmoi age decrypt --passphrase --output $KeyFile $EncFile
    if (Test-Path $KeyFile) {
      exit 0
    }
  } catch {}

  $attempt++
  Write-Host "Decrypt failed ($attempt/3), try again..."
}

exit 1
