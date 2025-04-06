$url = "https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-1.45.0-202501221836.tar.gz"
$download_path = "$env:TEMP/jdtls.tar.gz"
$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$install_path = "$tools_dir/jdtls";
Invoke-WebRequest -Method 'GET' -Uri $url -OutFile $download_path;
tar -xvzf $download_path --directory $install_path
Remove-Item $download_path
