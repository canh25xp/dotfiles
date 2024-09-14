$Env:EDITOR = "nvim"
$Env:PAGER = "less"
$Env:NVIM_APPNAME = "nvim"
$Env:KOMOREBI_CONFIG_HOME = "$HOME\.config\komorebi"
$Env:WHKD_CONFIG_HOME = "$HOME\.config\whkd"
$Env:TEALDEER_CONFIG_DIR = "$HOME\.config\tealdeer"
$Env:VCPKG_ROOT = "C:\vcpkg"

$Env:Path += ';C:\Program Files\pnnx-20230227-windows;'
$Env:Path += 'C:\Program Files\RePKG;'
$Env:Path += 'C:\Program Files\gdrive;'
$Env:Path += 'C:\Program Files\draw.io;'
$Env:Path += 'C:\Program Files\Inkscape\bin;'
$Env:Path += "$Env:VCPKG_ROOT"

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
