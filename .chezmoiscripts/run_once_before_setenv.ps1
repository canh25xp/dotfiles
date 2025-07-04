echo "================================================================================"
echo "[Chezmoi] windows set env"
# batch style
# setx WSLENV "USERPROFILE/p:LOCALAPPDATA/p"

# powershell style
$wslenv = [Environment]::GetEnvironmentVariable("WSLENV", [System.EnvironmentVariableTarget]::User)
if ($wslenv) {
	Write-Output "WSLENV already set to $wslenv. SKIP"
} else {
	[Environment]::SetEnvironmentVariable("WSLENV", "USERPROFILE/p:LOCALAPPDATA/p", [System.EnvironmentVariableTarget]::User)
	Write-Output "set WSLENV successfully"
}

[Environment]::SetEnvironmentVariable("POWERSHELL_UPDATECHECK", "Off", [System.EnvironmentVariableTarget]::User)
Write-Output "set POWERSHELL_UPDATECHECK successfully"

