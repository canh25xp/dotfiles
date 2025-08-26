vim.opt.cmdheight = vim.g.dynamic_cmdheight and 0 or 1
vim.opt.sessionoptions:append({ "globals", "skiprtp" })
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.termguicolors = true -- True color support
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.selectmode = "mouse"
vim.opt.pumblend = 0 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.pumwidth = 15 -- Minimum width for the popup menu
vim.opt.shortmess:append({ W = true, c = true, C = true })
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.confirm = true -- Ask to save changes before exiting modified buffer
vim.opt.laststatus = 3 -- global statusline
vim.opt.mousemoveevent = true
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.signcolumn = "yes:2" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.clipboard = "" -- Don't Sync clipboard between OS and Neovim.
vim.opt.breakindent = true
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = vim.g.vscode and 1000 or 500 -- Lower than default (1000) to quickly trigger which-key
vim.opt.inccommand = "split" -- Preview substitutions live, as you type
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.winborder = "rounded"
vim.opt.wrap = false -- Disable line wrap
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.splitright = true -- New splits should be opened right
vim.opt.splitbelow = true -- New splits should be opened below
vim.opt.list = true -- Display tabs, trailing spaces and non-breakable space characters.
vim.opt.wildignore:prepend("*.o", "*.obj", "*.pyc")

if vim.g.have_nerd_font then
  vim.opt.showbreak = "↳"
  vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
  }
  -- Use a bold seperators
  -- stylua: ignore
  vim.opt.fillchars = {
    horiz     = "━",
    horizup   = "┻",
    horizdown = "┳",
    vert      = "┃",
    vertleft  = "┫",
    vertright = "┣",
    verthoriz = "╋",
  }
else
  -- stylua: ignore
  vim.opt.fillchars = {
    horiz     = "-",
    horizup   = "-",
    horizdown = "-",
    vert      = "|",
    vertleft  = "|",
    vertright = "|",
    verthoriz = "+",
  }
end

if vim.g.is_windows then
  vim.opt.keywordprg = ":help"

  vim.o.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
  vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end
