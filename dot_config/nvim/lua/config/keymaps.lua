local map = vim.keymap.set
local utils = require("common.utils")
-- local terminal = require("common.terminal")

-- General
map("i", "jk", "<esc>", { desc = "Escape insert mode" })
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>QQ", "<cmd>wqa<cr>", { desc = "Write Quit All" })
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg (man page)" })
map("n", "<C-s>", "<cmd>wa<cr><esc>", { desc = "Save Files" })
map("n", "J", "mzJ`z", { desc = "Join without moving cursor" })
map("n", "<leader>//", [[/\<<C-r><C-w>\><cr>]], { desc = "Search word under cursor", silent = true })
map("n", "<leader>/s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })
map("n", "g|", "<cmd>vsplit<cr><C-]>", { desc = "Open in Split" })
map("n", "<leader>lp", ":lua =", { desc = "Lua print" })
map("n", "<leader>lo", ":lua =vim.opt.:get()<left><left><left><left><left><left>", { desc = "Lua print opts" })
map("n", "<leader>:", "gQ", { desc = "Enter Ex mode" })
map("n", "<leader>rc", [[<cmd>%s/\r//g|nohlsearch<CR>]], { desc = "Remove carriage return (^M)" }) -- ^M is <C-v><C-M>
map("n", "<leader>rw", [[<cmd>%s/\s\+$//e|nohlsearch<CR>]], { desc = "Remove trailing whitespaces" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Yank, Paste and Delete
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboad" })
map("n", "<leader>P", [["+P]], { desc = "Paste from system clipboard" })
map("n", "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
map("i", "<C-r><C-r>", [[<C-o>"+p]], { desc = "Paste form system clipboard" })
map("x", "<leader>p", [["_dP]], { desc = "Delete and Paste" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete" })
map("n", "<leader>0", [["0p"]], { desc = "Paste last yank" })

-- Netrw
map("n", "<leader>e", "<cmd>Lexplore<cr>", { desc = "Netrw Explorer (root)" })
map("n", "<leader>E", "<cmd>Lexplore %:p:h<cr>", { desc = "Netrw Explorer (cwd)" })

-- Lazy
map("n", "<leader>ll", utils.lazy_load, { desc = "Load Lazy Plugins" })
map("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Sessions
map("n", "<leader>qr", "<cmd>source Session.vim<cr>", { desc = "Restore Session" })
map("n", "<leader>qs", "<cmd>mksession!<cr>", { desc = "Save Session" })

-- UI
map("n", "<leader>us", utils.toggle_signcolmn, { desc = "Toggle Signcolumn" })
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle Wrap" })
map("n", "<leader>ur", "<cmd>nohlsearch|diffupdate|normal! <C-l><cr>", { desc = "Redraw / Clear hlsearch / Diff Update" })

-- Diagnostic
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code Diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Code Quickfix list" })
map("n", "<leader>cD", utils.toggle_diagnostic, { desc = "Toggle Diagnostics" })
map("n", "]d", utils.diagnostic_goto(1), { desc = "Next Diagnostic" })
map("n", "[d", utils.diagnostic_goto(-1), { desc = "Prev Diagnostic" })
map("n", "]e", utils.diagnostic_goto(1, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
map("n", "[e", utils.diagnostic_goto(-1, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
map("n", "]w", utils.diagnostic_goto(1, vim.diagnostic.severity.WARN), { desc = "Next Warning" })
map("n", "[w", utils.diagnostic_goto(-1, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })
map("n", "]i", utils.diagnostic_goto(1, vim.diagnostic.severity.INFO), { desc = "Next Info" })
map("n", "[i", utils.diagnostic_goto(-1, vim.diagnostic.severity.INFO), { desc = "Prev Info" })
map("n", "]h", utils.diagnostic_goto(1, vim.diagnostic.severity.HINT), { desc = "Next Hint" })
map("n", "[h", utils.diagnostic_goto(-1, vim.diagnostic.severity.HINT), { desc = "Prev Hint" })

-- Lsp
map("n", "gd", function() vim.lsp.buf.definition({ reuse_win = true }) end, { desc = "Goto Definition" })
map("n", "gD", function() vim.lsp.buf.declaration({ reuse_win = true }) end, { desc = "Goto Declaration" })
map("n", "gI", function() vim.lsp.buf.implementation({ reuse_win = true }) end, { desc = "Goto Implementation" })
map("n", "gY", function() vim.lsp.buf.type_definition({ reuse_win = true }) end, { desc = "Goto Type Definition" })
map("n", "gr", function() vim.lsp.buf.references() end, { desc = "Goto References" })
map("n", "gs", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
map("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename" })

-- Better scroll
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- Saner behavior of n and N
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Move Lines
map("n", "<leader>k", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("n", "<leader>j", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })

map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })

map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })

map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Srolling
map("n", "<left>", "zh", { desc = "Scroll left" })
map("n", "<right>", "zl", { desc = "Scroll right" })
map("n", "<up>", "<C-y>", { desc = "Scroll up" })
map("n", "<down>", "<C-e>", { desc = "Scroll down" })

-- Focusing
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper" })

-- Resizing
map("n", "<C-Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })

-- Terminal Mappings
-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Focus left" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Focus right" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Focus lower" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Focus upper" })
-- map("n", "<leader>tt", utils.tab_terminal, { desc = "New Tab Terminal" })
-- map("n", "<leader>md", utils.glow, { desc = "Markdown Preview with Glow" })
-- map("n", "<leader>gg", utils.lazygit, { desc = "Lazygit" })
-- map("n", "<leader>gl", utils.lazygit_log, { desc = "Lazygit Log" })
-- map("n", "<C-\\>", "<cmd>split|terminal<cr>", { desc = "New Terminal" })
-- map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map({"n", "t"}, "<C-\\>", terminal.Toggle, { desc = "Toggle Terminal" })
-- map("t", "jk", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
-- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
-- map("t", "<C-_>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- buffers
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bp|bd #<cr>", { desc = "Delete Current Buffer" })
map("n", "<leader>bo", utils.delete_other_buffers, { desc = "Delete Other Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
-- map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- windows
map("n", "<leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Create New Tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Delete Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
