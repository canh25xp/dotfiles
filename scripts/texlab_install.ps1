$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$download_link = "https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-windows.zip"
$download_path = "$tools_dir\texlab.zip"
$install_dir = "$tools_dir\texlab"

curl -L $download_link -o $download_path

7z x "$download_path" -o"$install_dir"

Remove-Item $download_path
