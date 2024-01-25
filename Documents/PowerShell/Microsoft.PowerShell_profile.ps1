# Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\velvet.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config ~/.velvet.omp.json | Invoke-Expression

# Load Terminal-Icons theme https://github.com/devblackops/Terminal-Icons
Import-Module -Name Terminal-Icons

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

# function Prompt {
#     # Your non-prompt logic here
#     $prompt = Write-Prompt "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor ([ConsoleColor]::Green)
#     $prompt += ":"
#     $prompt += & $GitPromptScriptBlock
#     $prompt
# }
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
