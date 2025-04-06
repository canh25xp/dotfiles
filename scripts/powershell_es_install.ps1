$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$DownloadUrl = 'https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/PowerShellEditorServices.zip';
$ZipPath = "$HOME/PowerShellEditorServices.zip";
$InstallPath = "$tools_dir/PowerShellEditorServices";
Invoke-WebRequest -Method 'GET' -Uri $DownloadUrl -OutFile $ZipPath;
Expand-Archive -Path $ZipPath -DestinationPath $InstallPath;
Remove-Item $ZipPath
