# function Prompt {
#     $env:USERNAME+"@"+$env:COMPUTERNAME+":"+"$($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
# }

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

function Prompt {
    # Your non-prompt logic here
    $prompt = Write-Prompt "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor ([ConsoleColor]::Green)
    $prompt += ":"
    $prompt += & $GitPromptScriptBlock
    $prompt
}