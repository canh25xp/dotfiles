$profileRoot = $PROFILE | Split-Path

. $profileRoot\Aliases.ps1

. $profileRoot\PSReadLineProfile.ps1

# The Default Prompt
# function Prompt {
#     $env:USERNAME+"@"+$env:COMPUTERNAME+":"+"$($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
# }

# Shell Prompt
# function Prompt {
#     $prompt = Write-Prompt "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor ([ConsoleColor]::Green)
#     $prompt += ":$($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
#     $prompt
# }
