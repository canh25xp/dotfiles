# ==============================================
# SHELL ALIASES
# ==============================================

# Bash like aliases
Set-Alias -Name su      -Value Start-AdminSession
Set-Alias -Name ff      -Value Find-File
Set-Alias -Name grep    -Value Find-String
Set-Alias -Name df      -Value Get-Volume
Set-Alias -Name which   -Value Show-Command
Set-Alias -Name ls      -Value Get-ChildItemList
Set-Alias -Name du      -Value Get-DirectorySummary

# Helpful aliases
Set-Alias -Name wifi    -Value Get-Wifi
Set-Alias -Name meme    -Value Show-Meme # Maybe not so helpful :v
Set-Alias -Name wtf     -Value Get-Command
Set-Alias -Name path    -Value Get-Path
Set-Alias -Name doc     -Value Show-Documents
Set-Alias -Name pro 	-Value Open-Profile
Set-Alias -Name word 	-Value Open-WinWord
Set-Alias -Name tere 	-Value Invoke-Tere
Set-Alias -Name cdx 	-Value Invoke-Tere

# Abbreviated aliases
Set-Alias -Name np      -Value notepad
Set-Alias -Name exp     -Value explorer
Set-Alias -Name vi      -Value nvim
Set-Alias -Name edit    -Value $env:EDITOR
Set-Alias -Name dl      -Value Get-FileFromInternet
Set-Alias -Name ytdl    -Value yt-dlp
Set-Alias -Name gitbash -Value Start-GitBash
Set-Alias -Name lgit    -Value lazygit
