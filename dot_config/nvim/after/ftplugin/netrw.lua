local map = vim.keymap.set

vim.g.netrw_keepdir = 0 -- Keep the current directory and the browsing directory synced. This
vim.g.netrw_winsize = 30 -- Change the size of the Netrw window
vim.g.netrw_banner = 0 -- Hide the banner ("I" to show agin)
vim.g.netrw_liststyle = 3 -- View as tree
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]] -- Hide dotfiles
vim.g.netrw_localcopydircmd = "cp -r" -- Change the copy command

map("n", "n", "%", { desc = "Netrw New file", remap = true, buffer = true })
map("n", "r", "R", { desc = "Netrw Rename file", remap = true, buffer = true })
map("n", "H", "gh", { desc = "Netrw Toggle Hidden", remap = true, buffer = true })
map("n", ".", "gh", { desc = "Netrw Toggle Hidden", remap = true, buffer = true })
map("n", "h", "-^", { desc = "Netrw go up", remap = true, buffer = true })
map("n", "l", "l<cr>", { desc = "Netrw open file", remap = true, buffer = true })
map("n", "P", "<C-w>z", { desc = "Netrw close preview", remap = true, buffer = true })
