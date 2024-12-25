Write-Host "================================================================================"
Write-Host "[Chezmoi] Install base winget packages"

$sourcePath = chezmoi source-path

winget import -i $sourcePath/scripts/winget_packages_base.json --no-upgrade
