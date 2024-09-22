# Very unstable and I didn't even tested for once

$USERPATH = "%LOCALAPPDATA%\Programs\Python\Python312\Scripts;%LOCALAPPDATA%\Programs\Python\Python312;%LOCALAPPDATA%\Programs\Python\Launcher;%LOCALAPPDATA%\Microsoft\WindowsApps;%LOCALAPPDATA%\Microsoft\WinGet\Links;%LOCALAPPDATA%\Programs\Microsoft VS Code\bin;%LOCALAPPDATA%\Programs\oh-my-posh\bin;%LOCALAPPDATA%\Programs\MiKTeX\miktex\bin\x64;%LOCALAPPDATA%\Microsoft\WinGet\Packages\ahrm.sioyek_Microsoft.Winget.Source_8wekyb3d8bbwe\sioyek-release-windows"
$MACHINEPATH = "%SystemRoot%;%SystemRoot%\system32;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\OpenSSH\;%SystemRoot%\System32\WindowsPowerShell\v1.0\;%PROGRAMFILES%\PowerShell\7;%PROGRAMFILES%\PowerShell\7-preview\preview;%PROGRAMFILES(X86)%\Common Files\Intel\Shared Libraries\redist\intel64\compiler;%PROGRAMFILES(X86)%\Windows Kits\10\Windows Performance Toolkit\;%PROGRAMFILES%\Microsoft SQL Server\150\Tools\Binn\;%PROGRAMFILES(X86)%\Gpg4win\..\GnuPG\bin;%PROGRAMFILES%\7-Zip;%PROGRAMFILES%\Alacritty;%PROGRAMFILES%\Android\Android Studio\bin;%PROGRAMFILES%\Arduino CLI;%PROGRAMFILES%\Git\cmd;%PROGRAMFILES%\GitHub CLI;%PROGRAMFILES%\CMake\bin;%PROGRAMFILES%\Docker\Docker\resources\bin;%PROGRAMFILES%\Neovim\bin;%PROGRAMFILES%\Neovide;%PROGRAMFILES%\bottom\bin;%PROGRAMFILES%\komorebi\bin;%PROGRAMFILES%\nodejs;%PROGRAMFILES%\whkd\bin;%PROGRAMFILES%\chocolatey\bin;C:\msys64\ucrt64\bin;C:\Strawberry\c\bin;C:\Strawberry\perl\bin;C:\Strawberry\perl\site\bin"

[Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User) > ~/.path.user.txt
[Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine) > ~/.path.machine.txt

[Environment]::SetEnvironmentVariable("PATH", "$USERPATH", [System.EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("PATH", "$MACHINEPATH", [System.EnvironmentVariableTarget]::Machine)
