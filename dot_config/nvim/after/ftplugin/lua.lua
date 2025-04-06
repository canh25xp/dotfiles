local map = vim.keymap.set
map("n", "<leader>cs", "<cmd>so<CR>", { buffer = 0, desc = "Source current file" })
map("v", "<leader>cs", "<cmd>'<,'>lua<CR>", { buffer = 0, desc = "Source current selection" })
