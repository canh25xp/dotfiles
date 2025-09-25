return {
  "catppuccin/nvim",
  enabled = true,
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  name = "catppuccin",
  keys = {
    {
      "<leader>ut",
      function()
        if vim.g.colors_name == "catppuccin-mocha" then
          vim.cmd.colorscheme("catppuccin-frappe")
        else
          vim.cmd.colorscheme("catppuccin-mocha")
        end
      end,
      desc = "Toggle Theme",
    },
    {
      "<leader>ub",
      function()
        local cat = require("catppuccin")
        cat.options.transparent_background = not cat.options.transparent_background
        cat.compile()
        vim.cmd.colorscheme(vim.g.colors_name)
      end,
      desc = "Toggle Transparency",
    },
    {
      "<leader>up",
      function()
        local cat = require("catppuccin")
        cat.options.transparent_background = false
        cat.options.color_overrides = {
          mocha = {
            text = "#F4CDE9",
            subtext1 = "#DEBAD4",
            subtext0 = "#C8A6BE",
            overlay2 = "#B293A8",
            overlay1 = "#9C7F92",
            overlay0 = "#866C7D",
            surface2 = "#705867",
            surface1 = "#5A4551",
            surface0 = "#44313B",

            base = "#352939",
            mantle = "#211924",
            crust = "#1a1016",
          },
        }
        cat.compile()
        vim.cmd.colorscheme(vim.g.colors_name)
      end,
      desc = "Toggle Transparency",
    },
  },
  opts = {
    compile_path = vim.fn.stdpath("config") .. "/.catppuccin",
    flavour = "auto", -- latte, frappe, macchiato, mocha
    transparent_background = true,
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    background = {
      light = "latte",
      dark = "mocha",
    },
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      fidget = true,
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
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
