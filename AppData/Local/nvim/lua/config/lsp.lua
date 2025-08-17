local icons = require("common.ui").icons

vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  severity_sort = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    prefix = "",
    header = "",
  },
})

vim.lsp.enable({
  "lua_ls",
})
