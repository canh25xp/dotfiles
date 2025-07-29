Write-Host "================================================================================"
Write-Host "[Chezmoi] Install winget packages"

$confirmation = Read-Host "Do you want to install winget packages? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "exit"
    exit
}

winget import $HOME/.local/share/chezmoi/.chezmoiscripts/.winget_packages.json --no-upgrade --disable-interactivity

