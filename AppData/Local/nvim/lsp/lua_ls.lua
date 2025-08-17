return {
  -- TODO: Add schemaStore support
  -- https://github.com/b0o/SchemaStore.nvim/issues/45
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
