return {
  settings = {
    texlab = {
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = false,
      },
      diagnostics = {
        ignoredPatterns = { "Unused label", "Undefined reference" },
      },
      experimental = {
        labelReferenceCommands = { "asmref", "goalref" },
        labelDefinitionCommands = { "asm", "goal" },
        labelReferencePrefixes = { { "asmref", "asm:" }, { "goalref", "goal:" } },
        labelDefinitionPrefixes = { { "asm", "asm:" }, { "goal", "goal:" } },
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {},
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = true,
      },
    },
  },
}
