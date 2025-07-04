Write-Host "================================================================================"
Write-Host "[Chezmoi] Install winget packages"

$confirmation = Read-Host "Do you want to install winget packages? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "exit"
    exit
}

echo "Need administrator privilege, expecting a prompt"

Start-Process -FilePath "wt" -Verb runAs -ArgumentList "powershell.exe &{ winget import {{ .chezmoi.sourceDir }}/scripts/winget_packages.json --no-upgrade --disable-interactivity }"

