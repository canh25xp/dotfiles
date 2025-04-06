return {
  "Civitasv/cmake-tools.nvim",
  lazy = true,
  dev = false,
  init = function()
    local loaded = false
    local function check()
      local cwd = vim.uv.cwd()
      if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        require("lazy").load({ plugins = { "cmake-tools.nvim" } })
        loaded = true
      end
    end
    check()
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        if not loaded then
          check()
        end
      end,
    })
  end,
  opts = {
    cmake_soft_link_compile_commands = false,
    cmake_compile_commands_from_lsp = true,
    cmake_executor = {
      name = "quickfix",
      opts = {
        show = "always", -- "always", "only_on_error"
        position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
        size = 10,
        encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
        auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
      },
    },
    cmake_runner = {
      name = "terminal",
      opts = {
        name = "Terminal",
        prefix_name = "[CMakeTools] ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
        split_direction = "horizontal", -- "horizontal", "vertical"
        split_size = 12,

        -- Window handling
        single_terminal_per_instance = true, -- Single viewport, multiple windows
        single_terminal_per_tab = true, -- Single viewport per tab
        keep_terminal_static_location = true, -- Static location of the viewport if avialable
        auto_resize = true, -- Resize the terminal if it already exists

        -- Running Tasks
        start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
        focus = false, -- Focus on terminal when cmake task is launched.
        do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
      },
    },
    cmake_notifications = {
      executor = { enabled = true },
      runner = { enabled = false },
      spinner = require("common.ui").spinner, -- icons used for progress display
      refresh_rate_ms = 100, -- how often to iterate icons
    },
    cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
  },
  keys = {
    { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
    { "<leader>cB", "<cmd>CMakeBuildCurrentFile<cr>", desc = "CMake Build Current File" },
    { "<leader>cx", "<cmd>CMakeRun<cr>", desc = "CMake Run Executable" },
    { "<leader>cX", "<cmd>CMakeRunCurrentFile<cr>", desc = "CMake Run Executable Current File" },
    { "<leader>cq", "<cmd>CMakeCloseRunner<cr>", desc = "CMake Close Runner" },
  },
}
