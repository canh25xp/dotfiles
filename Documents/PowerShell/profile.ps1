$env:EDITOR = "nvim"
$env:PAGER = "less"
$env:NVIM_APPNAME = "nvim"
$env:KOMOREBI_CONFIG_HOME = "$HOME\.config\komorebi"
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
--multi
--layout=reverse
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
$env:Path += "$env:VCPKG_ROOT;"

if (Test-Path("$PSScriptRoot\Aliases.ps1")) {
  . "$PSScriptRoot\Aliases.ps1"
}

if (Test-Path("$PSScriptRoot\PSReadLineProfile.ps1")) {
  . "$PSScriptRoot\PSReadLineProfile.ps1"
}


# Tab-copletions for winget
# Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
#     param($wordToComplete, $commandAst, $cursorPosition)
#         [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
#         $Local:word = $wordToComplete.Replace('"', '""')
#         $Local:ast = $commandAst.ToString().Replace('"', '""')
#         winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
#             [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
#         }
# }

# Tab-completions for `git`
# Import-Module -Name posh-git
# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# $GitPromptSettings.DefaultPromptEnableTiming = $true
# $GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Orange'
# $GitPromptSettings.DefaultPromptTimingFormat.Text = " [{0}ms]"

# Shell Prompt
# function Prompt {
#     $prompt = Write-Prompt "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor ([ConsoleColor]::Green)
#     $prompt += ":"
#     $prompt += & $GitPromptScriptBlock
#     $prompt
# }

# Tab-completions for `vcpkg`
# Import-Module "$env:VCPKG_ROOT\scripts\posh-vcpkg"

# Tab-completions for `choco` (https://ch0.co/tab-completion)
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
