# ==============================================
# SHELL APPEARANCES
# ==============================================

# Only enable outside of neovim
if ($null -eq $env:NVIM) {
  # Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
  oh-my-posh init pwsh --config "~/.config/oh-my-posh/powerline.omp.json" | Invoke-Expression
  # Using posh-git module for autocompletion
  $env:POSH_GIT_ENABLED = $true
}

# Terminal-Icons theme (https://github.com/devblackops/Terminal-Icons)
# Import-Module -Name Terminal-Icons

# Init zoxide
# (zoxide init powershell | Out-String) | Invoke-Expression
Invoke-Expression (& { (zoxide init --cmd j powershell | Out-String) })
