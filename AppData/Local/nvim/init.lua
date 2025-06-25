-- Use this to migrate vim to neovim
-- vim.opt.runtimepath:prepend("~/.vim/after")
-- vim.opt.packpath = vim.opt.runtimepath:get()
-- if vim.fn.filereadable("~/.vimrc") then
--   vim.cmd("source ~/.vimrc")
-- end

vim.g.mapleader = " " --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true
vim.g.load_lazy_plugins = true
vim.g.dynamic_cmdheight = true
vim.g.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
vim.g.is_linux = vim.fn.has("unix") == 1
vim.g.is_android = vim.fn.has("android") == 1
vim.g.is_wsl = vim.fn.has("wsl") == 1
vim.g.is_mac = vim.fn.has("mac") == 1
vim.g.path_sep = vim.g.is_windows and ";" or ":"

vim.g.loaded_perl_provider = 0 -- Disable perl provider
vim.g.loaded_ruby_provider = 0 -- Disable ruby provider
vim.g.loaded_node_provider = 0 -- Disable node provider
vim.g.loaded_python3_provider = 0 -- Disable python provider

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.usercommands")
if vim.g.load_lazy_plugins then
  require("config.lazy")
end

if vim.g.vscode then
  require("config.vscode")
end

if vim.g.neovide then
  require("config.neovide")
end

if vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = "nvr -l --remote-wait +'set bufhidden=delete'"
end
