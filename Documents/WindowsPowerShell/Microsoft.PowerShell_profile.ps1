# ==============================================
# SHELL INIT
# ==============================================

# Init oh-my-posh outside of neovim
$has_oh_my_posh = [bool](Get-Command -Name "oh-my-posh.exe" -ErrorAction SilentlyContinue)
if (!$Env:NVIM -and $has_oh_my_posh) {
  # Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
  oh-my-posh init pwsh --config "~/.config/oh-my-posh/catppuccin.omp.json" | Invoke-Expression
} else {
  function Prompt {
    #$prompt = "$env:USERNAME@$env:COMPUTERNAME "
    $prompt += "$($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    $prompt
  }
}

# Init zoxide
$has_zoxide = [bool](Get-Command -Name "zoxide.exe" -ErrorAction SilentlyContinue)
if ($has_zoxide) {
   zoxide init --cmd j powershell | Out-String | Invoke-Expression
}

if (Test-Path("$PSScriptRoot\Aliases.ps1")) {
  . "$PSScriptRoot\Aliases.ps1"
}

if (Test-Path("$PSScriptRoot\PSReadLineProfile.ps1")) {
  . "$PSScriptRoot\PSReadLineProfile.ps1"
}
