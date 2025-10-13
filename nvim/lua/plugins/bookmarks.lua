local find_or_create_project_bookmark_group = function()
  local project_root = vim.uv.cwd()
  if not project_root then
    return
  end

  local project_name = string.gsub(project_root, "^" .. os.getenv("HOME") .. "/", "")
  local Service = require("bookmarks.domain.service")
  local Repo = require("bookmarks.domain.repo")
  local bookmark_list = nil

  for _, bl in ipairs(Repo.find_lists()) do
    if bl.name == project_name then
      bookmark_list = bl
      break
    end
  end

  if not bookmark_list then
    bookmark_list = Service.create_list(project_name)
  end
  Service.set_active_list(bookmark_list.id)
  require("bookmarks.sign").safe_refresh_signs()
end

return {
  "LintaoAmons/bookmarks.nvim",
  lazy = true,
  tag = "3.2.0",
  dependencies = {
    { "kkharji/sqlite.lua" },
    { "nvim-telescope/telescope.nvim" },
    -- { "stevearc/dressing.nvim" }, -- optional: better UI
    -- { "GeorgesAlkhouri/nvim-aider" }, -- optional: for Aider integration
  },
  init = function()
    local db_path = vim.fn.stdpath("data") .. "/bookmarks.sqlite.db"
    if vim.fn.filereadable(db_path) == 1 then
      require("lazy").load({ plugins = { "bookmarks.nvim" } })
    end
  end,
  config = function()
    local opts = {} -- check the "./lua/bookmarks/default-config.lua" file for all the options
    require("bookmarks").setup(opts) -- you must call setup to init sqlite db
    vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
      group = vim.api.nvim_create_augroup("BookmarksGroup", {}),
      pattern = { "*" },
      callback = find_or_create_project_bookmark_group,
    })
  end,
  keys = {
    {
      "<leader>`",
      function()
        require("bookmarks.domain.service").toggle_mark("")
        require("bookmarks.sign").safe_refresh_signs()
        pcall(require("bookmarks.tree.operate").refresh)
      end,
      desc = "Toggle Mark",
    },
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
