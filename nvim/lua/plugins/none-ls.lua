return {
  "nvimtools/none-ls.nvim",
  cond = not vim.g.is_windows,
  opts = function(_, opts)
    local null_ls = require("null-ls")
    opts.root_dir = opts.root_dir or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
    opts.border = "rounded"
    opts.sources = vim.list_extend(opts.sources or {}, {
      -- null_ls.builtins.code_actions.gitsigns,
      -- null_ls.builtins.completion.spell,
      -- null_ls.builtins.diagnostics.codespell,
      -- null_ls.builtins.formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
      null_ls.builtins.hover.dictionary,
      null_ls.builtins.hover.printenv,
    })
  end,
}
