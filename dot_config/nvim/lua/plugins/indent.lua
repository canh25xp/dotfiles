local exclude_ft = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha", "dashboard" }

return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = false,
  event = "VeryLazy",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      -- -- U+2502 may also be a good choice, it will be on the middle of cursor.
      -- -- U+250A is also a good choice
      char = "▏",
    },
    scope = {
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = exclude_ft,
      buftypes = { "terminal" },
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
