Write-Host "================================================================================"
Write-Host "[Chezmoi] Install Spicetify theme"

git clone --depth=1 https://github.com/spicetify/spicetify-themes $HOME/spicetify-themes
git clone --depth=1 https://github.com/catppuccin/spicetify $HOME/spicetify

Copy-Item $HOME/spicetify/catppuccin "$(spicetify -c | Split-Path)\Themes\" -Recurse
Copy-Item $HOME/spicetify-themes "$(spicetify -c | Split-Path)\Themes\" -Recurse

spicetify config current_theme catppuccin
spicetify config color_scheme frappe
spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
spicetify apply

Remove-Item $HOME/spicetify -Recurse -Force
Remove-Item $HOME/spicetify-themes -Recurse -Force
