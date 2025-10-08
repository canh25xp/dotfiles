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
    { "<leader>mn", "<cmd>BookmarksNewList<cr>", desc = "New List" },
    { "<leader>ml", "<cmd>BookmarksLists<cr>", desc = "Mark Lists" },
    { "<leader>sm", "<cmd>BookmarksGoto<cr>", desc = "Search Mark" },
    { "<leader>ma", "<cmd>BookmarksCommands<cr>", desc = "All Mark Commands" },
    { "]B", "<cmd>BookmarksGotoNextInList<cr>", desc = "Next Bookmarks List" },
    { "[B", "<cmd>BookmarksGotoPrevInList<cr>", desc = "Prev Bookmarks List" },
    { "]b", "<cmd>BookmarksGotoNext<cr>", desc = "Next Bookmarks Line" },
    { "[b", "<cmd>BookmarksGotoPrev<cr>", desc = "Prev Bookmarks Line" },
  },
}
