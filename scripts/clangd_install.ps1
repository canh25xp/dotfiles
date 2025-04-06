$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$download_link = "https://github.com/clangd/clangd/releases/download/19.1.2/clangd-windows-19.1.2.zip"
$download_path = "$tools_dir\clangd.zip"
$install_dir = "$tools_dir\clangd"

curl -L $download_link -o $download_path

7z x "$download_path" -oclangd_tmp

mkdir $install_dir

Move-Item clangd_tmp/* $install_dir

Remove-Item clangd_tmp -Recurse

Remove-Item $download_path
