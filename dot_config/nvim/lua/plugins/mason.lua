return {
  "williamboman/mason.nvim",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    { "<leader>cI", "<cmd>MasonEnsureInstall<cr>", desc = "Install Mason Packages" }, -- new keybinding
  },
  opts = {
    ensure_installed = {
      "bash-language-server",
      "black",
      "clang-format",
      "clangd",
      "css-lsp",
      "deno",
      "eslint-lsp",
      "html-lsp",
      "isort",
      "jdtls",
      "json-lsp",
      "latexindent",
      "lua-language-server",
      "markdownlint",
      "marksman",
      "neocmakelsp",
      "powershell-editor-services",
      "prettier",
      "prettierd",
      "pyright",
      "ruff",
      "stylua",
      "taplo",
      "texlab",
      "yaml-language-server",
      "yamlfmt",
    },
    ui = {
      check_outdated_packages_on_open = false,
      border = "rounded",
      width = 0.9,
      height = 0.8,
      icons = require("common.ui").icons.mason,
      keymaps = {
        toggle_help = "?",
        uninstall_package = "x",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    vim.api.nvim_create_user_command("MasonEnsureInstall", function()
      local ensure_installed = opts.ensure_installed
      local registry = require("mason-registry")
      registry.refresh()
      local installed_package = registry.get_installed_package_names()

      for _, pkg_name in ipairs(ensure_installed) do
        local ok, pkg = pcall(registry.get_package, pkg_name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end, { desc = "Install all Mason ensured packages" })
  end,
}
