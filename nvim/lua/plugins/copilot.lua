return {
  {
    "github/copilot.vim",
    enable = true,
    cond = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        ["*"] = false,
        python = true,
        c = true,
        cpp = true,
        lua = true,
        tex = true,
        markdown = true,
      }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enable = true,
    cmd = "CopilotChat",
    opts = {
      model = "claude-3.5-sonnet",
      auto_insert_mode = true,
      show_help = true,
      show_folds = true,
      question_header = "  Michael ",
      answer_header = "  Copilot ",
      window = {
        layout = "horizontal",
        height = 0.4,
        border = "none",
      },
      mappings = {
        close = {
          insert = "C-q",
        },
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      require("CopilotChat").setup(opts)
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        ":CopilotChatCommit<cr>",
        desc = "Commit",
        mode = { "n", "v" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enable = false,
    cond = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
            accept_line = "<M-L>",
            accept_word = "<M-;>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          yaml = true,
          help = true,
          ["grug-far"] = false,
        },
      })
    end,
  },
}
