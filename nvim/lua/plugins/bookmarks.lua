return {
  "LintaoAmons/bookmarks.nvim",
  tag = "3.2.0",
  dependencies = {
    { "kkharji/sqlite.lua" },
    { "nvim-telescope/telescope.nvim" },
    -- { "stevearc/dressing.nvim" }, -- optional: better UI
    -- { "GeorgesAlkhouri/nvim-aider" }, -- optional: for Aider integration
  },
  config = function()
    local opts = {} -- check the "./lua/bookmarks/default-config.lua" file for all the options
    require("bookmarks").setup(opts) -- you must call setup to init sqlite db
  end,
  keys = {
    { "<leader>mm", "<cmd>BookmarksMark<cr>", desc = "Mark Line" },
  },
}
