return {
  "folke/tokyonight.nvim",
  enabled = false,
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    style = "storm", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
    light_style = "day", -- The theme is used when the background is set to light
    transparent = false, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  },
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}
