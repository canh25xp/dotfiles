# ==============================================
# SHELL APPEARANCES
# ==============================================

# Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
# $OMPTHEME = "$env:POSH_THEMES_PATH\agnoster.minimal.omp.json"
$OMPTHEME = "~/.config/oh-my-posh/powerline.omp.json"
oh-my-posh init pwsh --config $OMPTHEME | Invoke-Expression

# Terminal-Icons theme (https://github.com/devblackops/Terminal-Icons)
Import-Module -Name Terminal-Icons
