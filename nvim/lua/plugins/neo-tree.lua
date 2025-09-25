return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    -- { "<C-n>", ":Neotree action=show toggle=true<esc>", desc = "NeoTree Toggle" },
    { "<leader>e", "<leader>fe", desc = "NeoTree Explorer (root)", remap = true },
    { "<leader>E", "<leader>fE", desc = "NeoTree Explorer (cwd)", remap = true },
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "NeoTree Explorer (cwd)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({
          action = "focus", -- OPTIONAL, this is the default value
          source = "filesystem", -- OPTIONAL, this is the default value
          reveal_file = vim.fn.expand("%:p"), -- path to file or folder to reveal
          reveal_force_cwd = true, -- change cwd without asking if needed
        })
      end,
      desc = "NeoTree Explorer (root)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_pattern = {
            "**/*.log",
            "**/__pycache__",
          },
        },
      },
      window = {
        mappings = {
          ["<leader>e"] = "close_window",
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["."] = "toggle_hidden",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = false } },
        },
      },
    },
  },
}
