# ==============================================
# SHELL INIT
# ==============================================

$profileRoot = $PROFILE | Split-Path

. $profileRoot\Aliases.ps1

. $profileRoot\PSReadLineProfile.ps1

# Init startship or oh-my-posh
$has_startship = [bool](Get-Command -Name "starship.exe" -ErrorAction SilentlyContinue)
$has_oh_my_posh = [bool](Get-Command -Name "oh-my-posh.exe" -ErrorAction SilentlyContinue)
if ($has_startship) {
  starship init powershell | Invoke-Expression
} elseif ($has_oh_my_posh) {
  # Load Oh-my-posh theme https://ohmyposh.dev/docs/themes
  oh-my-posh init powershell --config "~/.config/oh-my-posh/catppuccin.omp.json" | Invoke-Expression
}

# Init zoxide
$has_zoxide = [bool](Get-Command -Name "zoxide.exe" -ErrorAction SilentlyContinue)
if ($has_zoxide) {
  zoxide init --cmd j powershell | Out-String | Invoke-Expression
}
