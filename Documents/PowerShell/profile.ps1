$env:EDITOR = "nvim"
$env:PAGER = "less"
$env:NVIM_APPNAME = "nvim"
$env:KOMOREBI_CONFIG_HOME = "$HOME\.config\komorebi"
$env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"
$env:YAZI_FILE_ONE  = "$env:PROGRAMFILES\Git\usr\bin\file.exe"
$env:WHKD_CONFIG_HOME = "$HOME\.config\whkd"
$env:TEALDEER_CONFIG_DIR = "$HOME\.config\tealdeer"
$env:CARGO_HOME = "$HOME\.cargo"
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:JAVA_HOME = "$env:PROGRAMFILES\Java\jdk-22"
$env:GRADLE_HOME = "C:\Gradle\gradle-8.10"
$env:MAVEN_HOME = "C:\Maven\apache-maven-3.9.9"
$env:VCPKG_ROOT = "C:\vcpkg"
$env:NVM_HOME = "$env:APPDATA\nvm"

# https://github.com/catppuccin/fzf
$env:FZF_DEFAULT_OPTS = @"
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--color=selected-bg:#45475a
--height=50%
--multi
--layout=reverse
--info=inline
"@

$env:Path += "$HOME\Documents\PowerShell\Scripts;"
$env:Path += "$env:PROGRAMFILES\gdrive;"
$env:Path += "$env:PROGRAMFILES\draw.io;"
$env:Path += "$env:PROGRAMFILES\Inkscape\bin;"
$env:Path += "$env:ANDROID_HOME\cmdline-tools\latest\bin;"
$env:Path += "$env:ANDROID_HOME\platform-tools;"
$env:Path += "$env:JAVA_HOME\bin;"
$env:Path += "$env:GRADLE_HOME\bin;"
$env:Path += "$env:MAVEN_HOME\bin;"
$env:Path += "$env:CARGO_HOME\bin;"
$env:Path += "$env:NVM_HOME;"
$env:Path += "$env:VCPKG_ROOT"

#$env:Path += "D:\Program Files\alacritty;"
#$env:Path += "D:\Program Files\bat;"
#$env:Path += "D:\Program Files\bottom;"
#$env:Path += "D:\Program Files\chezmoi;"
#$env:Path += "D:\Program Files\eza;"
#$env:Path += "D:\Program Files\fd;"
#$env:Path += "D:\Program Files\fzf;"
#$env:Path += "D:\Program Files\gh\bin;"
#$env:Path += "D:\Program Files\komorebi;"
#$env:Path += "D:\Program Files\lazygit;"
#$env:Path += "D:\Program Files\less;"
#$env:Path += "D:\Program Files\lf;"
#$env:Path += "D:\Program Files\mingw64\bin;"
#$env:Path += "D:\Program Files\neovide;"
#$env:Path += "D:\Program Files\neovim\bin;"
#$env:Path += "D:\Program Files\odin;"
#$env:Path += "D:\Program Files\oh-my-posh;"
#$env:Path += "D:\Program Files\ripgrep;"
#$env:Path += "D:\Program Files\tealdeer;"
#$env:Path += "D:\Program Files\terminal;"
#$env:Path += "D:\Program Files\whkd;"
#$env:Path += "D:\Program Files\zoxide;"
#$env:Path += "D:\Program Files\ffmpeg-7.1-essentials_build\bin;"
#$env:Path += "D:\Program Files\DumpstateViewer-3.5.2"
