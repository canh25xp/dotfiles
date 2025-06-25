return {
  {
    "folke/noice.nvim",
    enabled = true,
    cond = true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    opts = {
      lsp = {
        progress = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false, -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = false, -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = false, -- override the lsp markdown formatter with Noice
        },
        hover = {
          enabled = false,
          silent = false, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        signature = {
          enabled = false,
        },
      },
      cmdline = {
        view = "cmdline",
      },
      presets = {
        -- bottom_search = true, -- use a classic bottom cmdline for search
        -- command_palette = true, -- position the cmdline and popupmenu together
        -- long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = true, -- enables an input dialog for inc-rename.nvim
        -- lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      vim.api.nvim_del_augroup_by_name("Dynamic cmdheight")
      require("noice").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    enabled = true,
    cond = true,
    keys = {
      {
        "<leader>ua",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Display a log of the history",
      },
    },
    opts = {
      stages = "static",
      render = "wrapped-compact",
    },
  },
}
