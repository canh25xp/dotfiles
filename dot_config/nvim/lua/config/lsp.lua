local icons = require("common.ui").icons
local utils = require("common.utils")
local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic

diagnostic.config({
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

lsp.enable({
  "bashls",
  "clangd",
  "cssls",
  "eslint",
  "html",
  "jdtls",
  "jsonls",
  "lua_ls",
  "marksman",
  "neocmake",
  "powershell_es",
  "pyright",
  "ruff",
  "taplo",
  "texlab",
  "yamlls",
})

local capabilities = lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
else
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
end


local function on_init(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local function on_attach(client, bufnr)
  local function map(modes, keys, func, desc)
    vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  if client.server_capabilities.documentFormattingProvider then
    map({ "n", "x" }, "<leader>cF", function() lsp.buf.format({ async = true }) end, "Format")
  end

  if client.supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
    map("n", "<leader>uh", function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({})) end, "Toggle Inlay Hints")
  end

  -- Highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    local gid = api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

    -- highlight references of the word under cursor.
    api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = gid,
      callback = lsp.buf.document_highlight,
    })

    -- clear highlights when cursor moves.
    api.nvim_create_autocmd({ "CursorMoved" }, {
      buffer = bufnr,
      group = gid,
      callback = lsp.buf.clear_references,
    })

    api.nvim_create_autocmd("LspDetach", {
      group = api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
      callback = function(event_context)
        lsp.buf.clear_references()
        api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event_context.buf })
      end,
    })
  end

  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false -- Disable ruff hover in favor of Pyright
  end

  if client.name == "clangd" then
    map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Clangd Switch Source/Header")
  end
end

api.nvim_create_autocmd("LspAttach", {
  group = api.nvim_create_augroup("kickstart-lsp", { clear = true }),
  callback = function(event_context)
    local client = assert(lsp.get_client_by_id(event_context.data.client_id))
    local bufnr = event_context.buf
    on_attach(client, bufnr)
  end,
})

utils.signcolumn_single_sign()

vim.lsp.config("*", { capabilities = capabilities, on_init = on_init })
