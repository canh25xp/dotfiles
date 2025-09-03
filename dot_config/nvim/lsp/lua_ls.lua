return {
  filetypes = { "lua" },
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = { disable = { "missing-fields" } },
      runtime = {
        version = "LuaJIT",
      },
    },
  },
}
