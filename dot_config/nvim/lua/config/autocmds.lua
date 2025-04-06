--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local utils = require("common.utils")

local general = augroup("General Settings", { clear = true })

if vim.g.dynamic_cmdheight then
  autocmd({ "CmdlineEnter" }, {
    group = augroup("Dynamic cmdheight", { clear = false }),
    callback = function()
      vim.opt.cmdheight = 1
    end,
    desc = "Change cmdheight when typing macro or command",
  })
  autocmd({ "CmdlineLeave" }, {
    group = augroup("Dynamic cmdheight", { clear = false }),
    callback = function()
      vim.opt.cmdheight = 0
    end,
    desc = "Change cmdheight when leaving macro or command",
  })
end

-- autocmd("TermOpen", { pattern = "term://*", command = "setlocal nonumber norelativenumber signcolumn=no" })
-- autocmd("TermClose", { pattern = "term://*", command = "bdelete" })
-- autocmd({ "TermOpen", "WinEnter" }, { pattern = "term://*", command = "startinsert", desc = "Auto insert in terminal" })

autocmd("BufEnter", {
  pattern = "",
  callback = function()
    if vim.fn.argc() == 0 and vim.bo.filetype == "" then
      map("n", "r", "<leader>qr", { desc = "Restore Session", buffer = 0, remap = true })
    end
  end,
})

autocmd({ "VimResized" }, {
  desc = "Resize splits if window got resized",
  group = general,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = general,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- autocmd("BufEnter", {
--   pattern = { "*.md", "*.txt" },
--   callback = function()
--     vim.opt_local.spell = true
--   end,
--   group = general,
--   desc = "Enable spell checking",
-- })

autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "checkhealth",
    "netrw",
    "dap-float",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map("n", "qq", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quick Quit buffer" })
  end,
})
