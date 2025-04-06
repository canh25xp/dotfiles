return {
  "github/copilot.vim",
  enable = true,
  cond = false,
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_filetypes = {
      ["*"] = false,
      python = true,
      c = true,
      cpp = true,
      lua = true,
      tex = true,
      markdown = true,
    }
  end,
}

-- return {
--     "zbirenbaum/copilot.lua",
--     cmd = "Copilot",
--     build = ":Copilot auth",
--     event = "BufEnter",
--     config = function()
--         require("copilot").setup({
--             suggestion = {
--                 auto_trigger = true,
--                 keymap = {
--                     accept = "<M-l>",
--                     accept_line = "<M-L>",
--                     accept_word = "<M-;>",
--                 },
--             },
--             panel = { enabled = false },
--             filetypes = {
--                 markdown = true,
--                 yaml = true,
--                 help = true,
--                 ["grug-far"] = false,
--             },
--         })
--     end,
-- }
