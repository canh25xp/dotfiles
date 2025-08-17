Write-Host "================================================================================"
Write-Host "[Chezmoi] Install winget packages"

$confirmation = Read-Host "Do you want to install winget packages? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "exit"
    exit
}

winget import $HOME/Documents/winget/winget_packages.json --no-upgrade --disable-interactivity

