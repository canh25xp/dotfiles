return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      cond = function()
        return vim.fn.executable("cmake") == 1
      end,
      -- BUG: `&&` token does not works in legacy powershell
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    { "nvim-lua/plenary.nvim", version = false },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font, version = false },
  },
  config = function()
    -- Shows all keymaps for the current Telescope picker.
    -- Insert mode: <c-/>
    -- Normal mode: ?
    require("telescope").setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<c-enter>"] = "to_fuzzy_refine",
            ["<C-j>"] = require("telescope.actions").cycle_history_next,
            ["<C-k>"] = require("telescope.actions").cycle_history_prev,
          },
        },
      },
      pickers = {},
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_cursor(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- See `:help telescope.builtin`
    local map = vim.keymap.set
    local selected = require("common.utils").get_visual_selection
    local builtin = require("telescope.builtin")
    local map_opts = { noremap = true, silent = true }

    map("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
    map("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
    map("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
    map("n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })
    map("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
    map("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
    map("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
    map("n", "<leader>sr", builtin.resume, { desc = "Search Resume" })
    map("n", "<leader>s.", builtin.oldfiles, { desc = "Search Recent Files" })

    map("n", "<leader><leader>", function()
      builtin.find_files({ hidden = false, no_ignore = false})
    end, { desc = "Find Files" })

    map("n", "<leader>sa", function()
      builtin.find_files({ hidden = true, no_ignore = true})
    end, { desc = "Find All" })

    -- Slightly advanced example of overriding default behavior and theme
    map("n", "<leader>sz", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "Fuzzily search current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    map("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "Fuzzily search Open Files" })

    map("n", "<leader>sc", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Search Neovim Config files" })

    map("v", "<space>sz", function()
      local text = selected()
      builtin.current_buffer_fuzzy_find({ default_text = text })
    end, map_opts)

    map("v", "<space>sg", function()
      local text = selected()
      builtin.live_grep({ default_text = text })
    end, map_opts)
  end,
}
