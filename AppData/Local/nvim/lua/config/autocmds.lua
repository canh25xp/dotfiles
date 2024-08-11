--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("common.utils")

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("TermOpen", { command = "setlocal nonumber norelativenumber signcolumn=no" })

autocmd({ "TermOpen", "WinEnter" }, { pattern = "term://*", command = "startinsert" })

autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})
