Write-Host "================================================================================"
Write-Host "[Chezmoi] Install winget extra packages extra"

$confirmation = Read-Host "Do you want to install winget packages extra? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "exit"
    exit
}

winget import {{ .chezmoi.sourceDir }}/scripts/winget_packages_extra.json --no-upgrade --disable-interactivity

