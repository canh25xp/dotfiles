# Set policy to avoid errors
#Set-ExecutionPolicy RemoteSigned -scope CurrentUser

$tools_dir = "$env:LOCALAPPDATA\nvim-data\tools"
$download_link = "https://github.com/LuaLS/lua-language-server/releases/download/3.10.6/lua-language-server-3.10.6-win32-x64.zip"
$download_path = "$tools_dir\lua-language-server.zip"
$install_dir = "$tools_dir\lua-language-server"

curl -L $download_link -o $download_path

7z x "$download_path" -o"$install_dir"

Remove-Item $download_path

# Setup PATH env variable, ref: https://stackoverflow.com/q/714877/6064933
#[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$lua_ls_dir\bin", "Machine")
