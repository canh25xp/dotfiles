# ==============================================
# SHELL APPEARANCES
# ==============================================

# Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
oh-my-posh init pwsh --config "~/.config/oh-my-posh/powerline.omp.json" | Invoke-Expression

# Terminal-Icons theme (https://github.com/devblackops/Terminal-Icons)
Import-Module -Name Terminal-Icons

# Using posh-git module for autocompletion
$env:POSH_GIT_ENABLED = $true
