# ==============================================
# SHELL ALIASES
# ==============================================

# Bash like aliases
Set-Alias -Name su      -Value Start-AdminSession
Set-Alias -Name ff      -Value Find-File
Set-Alias -Name grep    -Value Find-String
Set-Alias -Name df      -Value Get-Volume
Set-Alias -Name which   -Value Show-Command
Set-Alias -Name ls      -Value Get-ChildItemPretty
Set-Alias -Name la      -Value Get-ChildItemPrettyAll
Set-Alias -Name ll      -Value Get-ChildItemPrettyLong
Set-Alias -Name du      -Value Get-DirectorySummary

# Helpful aliases
Set-Alias -Name wifi    -Value Get-Wifi
Set-Alias -Name meme    -Value Show-Meme # Maybe not so helpful :v
Set-Alias -Name wtf     -Value Get-Command
Set-Alias -Name path    -Value Get-Path
Set-Alias -Name doc     -Value Show-Documents
Set-Alias -Name pro     -Value Open-Profile
Set-Alias -Name word    -Value Open-WinWord
Set-Alias -Name cdx     -Value Open-ListFile

# Abbreviated aliases
Set-Alias -Name np      -Value notepad
Set-Alias -Name exp     -Value explorer
Set-Alias -Name vi      -Value nvim
Set-Alias -Name vim     -Value nvim
Set-Alias -Name edit    -Value $env:EDITOR
Set-Alias -Name lgit    -Value lazygit
Set-Alias -Name cm      -Value chezmoi
