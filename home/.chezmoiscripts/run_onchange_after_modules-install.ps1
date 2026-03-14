Write-Host "================================================================================"
Write-Host "[Chezmoi] Install PS Modules"

$confirmation = Read-Host "Do you want to install PS Modules? (Y/n)"

if ($confirmation -eq 'n') {
  Write-Host "Skip"
  exit
}

Install-Script -Name winfetch
Install-Module -Name PowerShell-Beautifier
Install-Module -Name PoshFunctions
