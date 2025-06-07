return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "ray-x/lsp_signature.nvim", version = false },
      "b0o/schemaStore.nvim",
    },
    event = { "BufRead", "BufNewFile" },
    opts = {
      inlay_hints = {
        enabled = true,
        exclude = { "lua_ls" },
      },
      servers = {
        lua_ls = {
          executable = "lua-language-server",
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
        },
        jsonls = {
          executable = "vscode-json-language-server",
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        eslint = {
          executable = "vscode-eslint-language-server",
        },
        cssls = {
          executable = "vscode-css-language-server",
        },
        html = {
          executable = "vscode-html-language-server",
        },
        yamlls = {
          executable = "yaml-language-server",
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").yaml.schemas())
          end,
          settings = {
            yaml = {
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
        clangd = {
          filetypes = { "c", "cpp", "cc" },
          flags = {
            debounce_text_changes = 500,
          },
          cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
          init_options = {
            fallback_flags = { "-std=c++17" },
          },
          on_new_config = function(new_config, new_cwd)
            local status, cmake = pcall(require, "cmake-tools")
            if status then
              cmake.clangd_on_new_config(new_config)
            end
          end,
        },
        neocmake = {
          executable = "neocmakelsp"
        },
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Using Ruff's import organizer
            },
            python = {
              analysis = {
                -- TODO: onlny ignore if ruff is attached
                ignore = { "*" }, -- Ignore all files for analysis to exclusively use Ruff for linting
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              lineLength = 120,
            },
          },
        },
        jdtls = {},
        texlab = {
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
        },
        marksman = {},
        ltex = {
          executable = "ltex-ls",
          cmd = { "ltex-ls" },
          filetypes = { "text", "plaintex", "tex", "markdown" },
          settings = {
            ltex = {
              language = "en",
            },
          },
          flags = { debounce_text_changes = 300 },
        },
        powershell_es = {
          executable = "pwsh", -- work around to detect if windows
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
          shell = vim.o.shell,
          settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
        },
        bashls = {
          executable = "bash-language-server",
        },
        vimls = {
          executable = "vim-language-server",
        },
        taplo = {},
      },
    },
    config = function(_, opts)
      local api = vim.api
      local lsp = vim.lsp
      local sep = vim.g.path_sep
      local utils = require("common.utils")

      local tools_bin = vim.fn.stdpath("data") .. "/tools"
      local luals_bin = tools_bin .. "/lua-language-server/bin"
      local jdtls_bin = tools_bin .. "/jdtls/bin"
      local clangd_bin = tools_bin .. "/clangd/bin"
      local texlab_bin = tools_bin .. "/texlab"

      vim.env.PATH = luals_bin .. sep .. vim.env.PATH
      vim.env.PATH = jdtls_bin .. sep .. vim.env.PATH
      vim.env.PATH = clangd_bin .. sep .. vim.env.PATH
      vim.env.PATH = texlab_bin .. sep .. vim.env.PATH

      local function lsp_attach(client, bufnr)
        local function map(modes, keys, func, desc)
          vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- stylua: ignore start
        map("n", "gd", function() lsp.buf.definition({ reuse_win = true }) end, "Goto Definition")
        map("n", "gD", function() lsp.buf.declaration({ reuse_win = true }) end, "Goto Declaration")
        map("n", "gI", function() lsp.buf.implementation({ reuse_win = true }) end, "Goto Implementation")
        map("n", "gY", function() lsp.buf.type_definition({ reuse_win = true }) end, "Goto Type Definition")
        map("n", "gr", function() lsp.buf.references() end, "Goto References")
        map("n", "gs", function() lsp.buf.signature_help() end, "Signature help")
        map("i", "<C-k>", function() lsp.buf.signature_help() end, "Signature help")
        map("n", "<leader>cr", function() lsp.buf.rename() end, "Rename")
        map("n", "<leader>ca", function() lsp.buf.code_action() end, "Code Action")
        -- stylua: ignore end

        if client.server_capabilities.documentFormattingProvider then
          map({ "n", "x" }, "<leader>cF", function()
            lsp.buf.format({ async = true })
          end, "Format")
        end

        if client.supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
          if not vim.tbl_contains(opts.inlay_hints.exclude, client.name) then
            lsp.inlay_hint.enable(opts.inlay_hints.enabled)
          end

          map("n", "<leader>uh", function()
            lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({}))
          end, "Inlay Hints Toggle")
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

          api.nvim_create_autocmd("lspdetach", {
            group = api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              lsp.buf.clear_references()
              api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        require("lsp_signature").on_attach({
          bind = true,
          handler_opts = {
            border = "rounded",
          },
          toggle_key = "<C-k>",
        }, bufnr)

        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false -- Disable hover in favor of Pyright
        end

        if client.name == "clangd" then
          map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Clangd Switch Source/Header")
        end
      end

      local capabilities = lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")
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

      utils.set_lsp_border("rounded")
      utils.signcolumn_single_sign()

      for server, config in pairs(opts.servers) do
        local executable = config.executable or server
        if utils.executable(executable) then
          lspconfig[server].setup(vim.tbl_deep_extend("force", {
            on_attach = lsp_attach,
            capabilities = capabilities,
          }, config))
        end
      end
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  {
    "b0o/schemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      ast = require("common.ui").icons.ast,
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("clangd_extensions").setup(opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    lazy = true,
    enabled = false,
    opts = {},
  },
  {
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
  },
}
