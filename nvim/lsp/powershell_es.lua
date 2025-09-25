return {
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
  shell = vim.o.shell,
  settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
}
