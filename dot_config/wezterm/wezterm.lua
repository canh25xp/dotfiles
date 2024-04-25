-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 12

config.enable_tab_bar = true

config.hide_tab_bar_if_only_one_tab = true

config.unzoom_on_switch_pane = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Shell
config.default_prog = { "pwsh", "-NoLogo" }

return config
