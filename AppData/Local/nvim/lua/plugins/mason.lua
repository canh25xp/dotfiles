return {
  "williamboman/mason.nvim",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  opts = {
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

    local masonpath = vim.fn.stdpath("data") .. "/mason/.first_run_complete"
    if not (vim.uv or vim.loop).fs_stat(masonpath) then
      local registry = require("mason-registry")
      local packages = {
        "black",
        "clangd",
        "css-lsp",
        "eslint-lsp",
        "html-lsp",
        "isort",
        "jdtls",
        "json-lsp",
        "latexindent",
        "lua-language-server",
        "markdownlint",
        "marksman",
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
      }

      for _, pkg_name in ipairs(packages) do
        local ok, pkg = pcall(registry.get_package, pkg_name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end

      vim.fn.mkdir(vim.fn.fnamemodify(masonpath, ":h"), "p")
      local f = io.open(masonpath, "w")
      if f then
        f:write("installed")
        f:close()
      end
    end
  end,
}
