local map = vim.keymap.set
local mp = require("mini.pairs")
mp.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" })

vim.o.textwidth = 120
vim.o.wrap = true

map("v", "<localleader>sm", "<esc>`<i$<esc>`>la$<esc>", { desc = "Surround with Math Mode" })
map("n", "<localleader>sm", "ciW$<esc>pa$<esc>", { desc = "Surround with Math Mode" })

map("v", "<localleader>st", [[s\text{ <esc>pa }<esc>]], { desc = "Surround with text" })
map("n", "<localleader>st", [[ciW\text{ <esc>pa }<esc>]], { desc = "Surround with text" })

map("n", "<leader>ch", "<CMD>!xdg-open https://quickref.me/latex &<CR>", { desc = "Open LaTeX Cheatsheet", silent=true})
