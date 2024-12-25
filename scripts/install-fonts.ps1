Write-Host "================================================================================"
Write-Host "[Chezmoi] Install fonts"

$confirmation = Read-Host "Do you want to install fonts? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "Skip fonts"
    exit
}

$script = [scriptblock]::Create((Invoke-WebRequest 'https://to.loredo.me/Install-NerdFont.ps1'))

$fontList = & $script -List All

& $script -Confirm:$false -Name Cascadia-Code
