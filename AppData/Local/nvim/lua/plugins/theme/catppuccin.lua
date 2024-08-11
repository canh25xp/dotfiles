return {
  "catppuccin/nvim",
  enabled = true,
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  name = "catppuccin",
  opts = {
    flavour = "auto", -- latte, frappe, macchiato, mocha
    transparent_background = false,
    background = {
      light = "latte",
      dark = "mocha",
    },
    dim_inactive = {
      enabled = true, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.5, -- percentage of the shade to apply to the inactive window
    },
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
  config = function()
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
