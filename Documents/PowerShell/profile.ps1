# Current User All Hosts
$Env:EDITOR = "nvim"
# $Env:TERM = "tmux"
# $Env:TERM = "ms-terminal"

$Env:Path += 'D:\Program Files\pnnx-20230227-windows;'
$Env:Path += 'D:\Program Files\git-filter-repo;'
$Env:Path += 'D:\Program Files\RePKG;'
$Env:Path += 'D:\Program Files\gdrive;'
$Env:Path += 'D:\Program Files\draw.io;'
$Env:Path += 'D:\Program Files\Inkscape\bin;'
$Env:Path += 'D:\Program Files\du;'

if (Test-Path("$PSScriptRoot\Functions.psm1")) {
  Import-Module "$PSScriptRoot\Functions.psm1"
}

if (Test-Path("$PSScriptRoot\Aliases.ps1")) {
  . "$PSScriptRoot\Aliases.ps1"
}


if (Test-Path("$PSScriptRoot\PSReadLineProfile.ps1")) {
  . "$PSScriptRoot\PSReadLineProfile.ps1"
}

# Tab-copletions for winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

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

# Tab-completions for `arduino-cli`
# . "$PSScriptRoot\arduino-cli.ps1"

# Tab-completions for `vcpkg`
# Import-Module "$env:VCPKG_ROOT\scripts\posh-vcpkg"

# Tab-completions for `choco` (https://ch0.co/tab-completion)
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
