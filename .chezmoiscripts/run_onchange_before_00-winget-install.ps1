Write-Host "================================================================================"
Write-Host "[Chezmoi] Install winget packages"

$confirmation = Read-Host "Do you want to install winget packages? (Y/n)"

if ($confirmation -eq 'n') {
  Write-Host "Skip"
  exit
}

$wingetPackages = "$HOME\Documents\winget\winget_packages.json"
$tempWingetPackges = Join-Path ([System.IO.Path]::GetTempPath()) ("winget_packages_{0}.json" -f ([System.Guid]::NewGuid().ToString()))

# Copy original to temp file
Copy-Item $wingetPackages $tempWingetPackges -Force

$editConfirmation = Read-Host "Do you want to edit the winget_packages.json file before installing? (Y/n)"

if ($editConfirmation -ne 'n') {
  if (Get-Command nvim -ErrorAction SilentlyContinue) {
    nvim $tempWingetPackges
  }
  else {
    # Wait for notepad to close
    Start-Process notepad $tempWingetPackges -Wait
  }
}

winget import $tempWingetPackges --no-upgrade --disable-interactivity

Remove-Item $tempWingetPackges -Force
