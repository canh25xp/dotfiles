return {
  "stevearc/conform.nvim",
  dependencies = { "williamboman/mason.nvim" },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Code Format",
    },
    {
      "<leader>ci",
      "<cmd>ConformInfo<CR>",
      mode = "n",
      desc = "Conform Info",
    },
  },
  opts = {
    notify_on_error = false,
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = "fallback", -- not recommended to change
    },
    -- format_on_save = function(bufnr)
    --   -- Disable "format_on_save lsp_fallback" for languages that don't have a well standardized coding style.
    --   local disable_filetypes = {
    --     c = true,
    --     cpp = true,
    --   }
    --   return {
    --     timeout_ms = 500,
    --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    --   }
    -- end,
    formatters_by_ft = {
      ps1 = { "pwsh_formatter" },
      lua = { "stylua" },
      sh = { "shfmt" },
      tex = { "latexindent" },
      python = { "ruff_format", "isort", "black", stop_after_first = true },
      markdown = { "prettierd", "markdownlint" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettier" },
      jsonc = { "prettier" },
      css = { "prettierd" },
      html = { "prettierd" },
      yaml = { "prettierd" },
      toml = { "taplo" },
    },
    formatters = {
      pwsh_formatter = {
        command = vim.o.shell,
        args = {
          "-NoProfile",
          "-Command",
          "Edit-DTWBeautifyScript",
          "$FILENAME",
        },
        stdin = false,
      },
      latexindent = {
        prepend_args = { "-l", "-m" },
      },
    },
  },
}
