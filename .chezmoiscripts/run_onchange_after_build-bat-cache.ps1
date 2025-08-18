Write-Host "================================================================================"
Write-Host "[Chezmoi] Building bat theme (catppuccin)"

# Check if bat is installed
if (-not (Get-Command bat -ErrorAction SilentlyContinue)) {
  Write-Host "'bat' is not installed. Exiting."
  exit 1
}

$confirmation = Read-Host "Build bat theme? (Y/n)"
if (-not $confirmation) {
  $confirmation = "Y"
}

if ($confirmation -notmatch '^[Yy]$') {
  Write-Host "Canceled."
  exit 0
}

bat cache --build
