Write-Host "================================================================================"
Write-Host "[Chezmoi] Install base winget packages"

$confirmation = Read-Host "Do you want to install winget packages? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "Skip winget packages"
    exit
}

$sourcePath = chezmoi source-path

sudo winget import -i $sourcePath/scripts/winget_packages.json --no-upgrade --disable-interactivity