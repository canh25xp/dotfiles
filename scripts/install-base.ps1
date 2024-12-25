Write-Host "================================================================================"
Write-Host "[Chezmoi] Install base winget packages"

$sourcePath = chezmoi source-path

winget import -i $sourcePath/scripts/winget_packages_base.json --no-upgrade

$confirmation = Read-Host "Do you want to install fonts? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "Skip fonts"
    exit
}

$script = [scriptblock]::Create((iwr 'https://to.loredo.me/Install-NerdFont.ps1'))

$fontList = & $script -List All

& $script -Confirm:$false -Name Cascadia-Code
