Write-Host "================================================================================"
Write-Host "[Chezmoi] Install winget packages"

$confirmation = Read-Host "Do you want to install winget packages? (Y/n)"

if ($confirmation -eq 'n') {
  Write-Host "Skip"
  exit
}

$wingetPackages = "$HOME\Documents\winget\winget_packages.json"

$editConfirmation = Read-Host "Do you want to edit the winget_packages.json file before installing? (Y/n)"

if ($editConfirmation -ne 'n') {
  if (Get-Command nvim -ErrorAction SilentlyContinue) {
    nvim $wingetPackages
  }
  else {
    # Wait for notepad to close
    Start-Process notepad -ArgumentList $wingetPackages -Wait
  }
}

winget import $wingetPackages --no-upgrade --disable-interactivity
