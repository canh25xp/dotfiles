# ==============================================
# SHELL INIT
# ==============================================

$profileRoot = $PROFILE | Split-Path

. $profileRoot\Aliases.ps1

. $profileRoot\PSReadLineProfile.ps1

# Init startship or oh-my-posh
$has_startship = [bool](Get-Command -Name "starship.exe" -ErrorAction SilentlyContinue)
$has_oh_my_posh = [bool](Get-Command -Name "oh-my-posh.exe" -ErrorAction SilentlyContinue)
if ($has_startship) {
  starship init powershell | Invoke-Expression
} elseif ($has_oh_my_posh) {
  # Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
  oh-my-posh init pwsh --config "~/.config/oh-my-posh/catppuccin.omp.json" | Invoke-Expression
}

# Init zoxide
$has_zoxide = [bool](Get-Command -Name "zoxide.exe" -ErrorAction SilentlyContinue)
if ($has_zoxide) {
  zoxide init --cmd j powershell | Out-String | Invoke-Expression
}

# Terminal-Icons theme (https://github.com/devblackops/Terminal-Icons)
# Import-Module -Name Terminal-Icons

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
