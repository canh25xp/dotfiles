return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "bibtex",
      "c",
      "cmake",
      "cpp",
      "diff",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "groovy",
      "html",
      "ini",
      "java",
      "javascript",
      "json",
      "json5",
      "kotlin",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "powershell",
      "properties",
      "python",
      "query",
      "readline",
      "requirements",
      "scss",
      "ssh_config",
      "tmux",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    -- Autoinstall languages that are not installed
    auto_install = false,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      -- If you are experiencing weird indenting issues,
      -- add the language to the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
      disable = function()
        if string.find(vim.bo.filetype, "chezmoitmpl") or vim.bo.filetype == "tex" or vim.bo.filetype == "tmux" then
          return true
        end
      end,
    },
    indent = {
      enable = true,
      disable = { "ruby" },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact with nvim-treesitter.
    -- You should go explore a few and see what interests you:
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
