local map = vim.keymap.set
local vscode = require("vscode")

-- vscode specific key bindings
map("n", "<leader>cf", function()
  vscode.action("editor.action.formatDocument")
end)

map("n", "<leader>gg", function()
  vscode.action("workbench.view.scm")
end)

map("n", "<leader>e", function()
  vscode.action("workbench.view.explorer")
end)

map("n", "<leader>E", function()
  vscode.action("workbench.files.action.showActiveFileInExplorer")
end)

map("n", "<leader>j", function()
  vscode.action("workbench.action.togglePanel")
end)
