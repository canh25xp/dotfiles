# ==============================================
# SHELL INIT
# ==============================================

# Only enable outside of neovim
if ($null -eq $Env:NVIM) {
  # Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
  oh-my-posh init pwsh --config "~/.config/oh-my-posh/catppuccin.omp.json" | Invoke-Expression
  # Using posh-git module for autocompletion
  $env:POSH_GIT_ENABLED = $true
}

# Init zoxide
# (zoxide init powershell | Out-String) | Invoke-Expression
Invoke-Expression (& { (zoxide init --cmd j powershell | Out-String) })

# Terminal-Icons theme (https://github.com/devblackops/Terminal-Icons)
# Import-Module -Name Terminal-Icons
