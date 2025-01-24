# UNIX common
$env:EDITOR = "nvim"
$env:PAGER = "less -R"

# Perforce
$env:P4ENVIRO = "$HOME\.config\p4\p4enviro.txt"
$env:P4ALIASES = "$HOME\.config\p4\p4aliases.txt"
$env:P4TICKETS = "$HOME\.p4tickets.txt"

# Komorebi & whkd
$env:KOMOREBI_CONFIG_HOME = "$HOME\.config\komorebi"
$env:WHKD_CONFIG_HOME = "$HOME\.config\whkd"

# yazi
$env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"
$env:YAZI_FILE_ONE = "$env:PROGRAMFILES\Git\usr\bin\file.exe"

# tealdeer
$env:TEALDEER_CONFIG_DIR = "$HOME\.config\tealdeer"

# FZF config & theme https://github.com/catppuccin/fzf
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

# SDKs & package managers
if (Test-Path "$HOME\.cargo") {
  $env:CARGO_HOME = "$HOME\.cargo"
  $env:Path += "$env:CARGO_HOME\bin;"
}

if (Test-Path "$HOME\vcpkg") {
  $env:VCPKG_ROOT = "$HOME\vcpkg"
  $env:Path += "$env:VCPKG_ROOT;"
}

if (Test-Path "$HOME\scoop") {
  $env:SCOOP_HOME = "$HOME\scoop"
  $env:Path += "$env:SCOOP_HOME\shims;"
}

if (Test-Path "$env:APPDATA\nvm") {
  $env:NVM_HOME = "$env:APPDATA\nvm"
  $env:Path += "$env:NVM_HOME;"
}

if (Test-Path "$env:PROGRAMFILES\Java\jdk-22") {
  $env:JAVA_HOME = "$env:PROGRAMFILES\Java\jdk-22"
  $env:Path += "$env:JAVA_HOME\bin;"
}

if (Test-Path "$env:LOCALAPPDATA\Android\Sdk") {
  $env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
  $env:Path += "$env:ANDROID_HOME\cmdline-tools\latest\bin;"
  $env:Path += "$env:ANDROID_HOME\platform-tools;"
}

if (Test-Path "C:\Gradle\gradle-8.10") {
  $env:GRADLE_HOME = "C:\Gradle\gradle-8.10"
  $env:Path += "$env:GRADLE_HOME\bin;"
}

if (Test-Path "C:\Maven\apache-maven-3.9.9") {
  $env:MAVEN_HOME = "C:\Maven\apache-maven-3.9.9"
  $env:Path += "$env:MAVEN_HOME\bin;"
}

if (Test-Path "$HOME\miniforge3") {
  $env:CONDA_ROOT = "$HOME\miniforge3"
  $env:Path += "$env:CONDA_ROOT\Scripts;"
}

# User programs
$env:Path += "$HOME\Documents\PowerShell\Scripts;"
$env:Path += "$env:LOCALAPPDATA\SumatraPDF;"
$env:Path += "$env:PROGRAMFILES\gdrive;"
$env:Path += "$env:PROGRAMFILES\NirCmd;"
$env:Path += "$env:PROGRAMFILES\draw.io;"
$env:Path += "$env:PROGRAMFILES\Inkscape\bin;"

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
#if (Test-Path "$HOME\miniforge3\Scripts\conda.exe") {
#  (& "$HOME\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
#}
#endregion

