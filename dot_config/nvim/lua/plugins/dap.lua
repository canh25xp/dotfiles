---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

local function telescope_pick()
  return coroutine.create(function(coro)
    local opts = {}
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
      .new(opts, {
        prompt_title = "Path to executable",
        finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" }, {}),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(buffer_number)
          actions.select_default:replace(function()
            actions.close(buffer_number)
            coroutine.resume(coro, action_state.get_selected_entry()[1])
          end)
          return true
        end,
      })
      :find()
  end)
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    -- stylua: ignore
    keys = {
      { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
      { "<F5>",       function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>",      function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end, desc = "Debug: Step In" },
      { "<F12>",      function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Set Breakpoint", },
      { "<leader>dd", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Debug: Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Debug: Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Debug: Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Debug: Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Debug: Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Debug: Widgets" },
      --[[ .exit                      Closes the REPL ]]
      --[[ .c or .continue            Same as |dap.continue| ]]
      --[[ .n or .next                Same as |dap.step_over| ]]
      --[[ .into                      Same as |dap.step_into| ]]
      --[[ .into_target               Same as |dap.step_into{askForTargets=true}| ]]
      --[[ .out                       Same as |dap.step_out| ]]
      --[[ .up                        Same as |dap.up| ]]
      --[[ .down                      Same as |dap.down| ]]
      --[[ .goto                      Same as |dap.goto_| ]]
      --[[ .scopes                    Prints the variables in the current scopes ]]
      --[[ .threads                   Prints all threads ]]
      --[[ .frames                    Print the stack frames ]]
      --[[ .capabilities              Print the capabilities of the debug adapter ]]
      --[[ .b or .back                Same as |dap.step_back| ]]
      --[[ .rc or .reverse-continue   Same as |dap.reverse_continue| ]]
    },
    config = function()
      local dap = require("dap")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(require("common.ui").icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        ---@diagnostic disable-next-line: assign-type-mismatch
        vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] })
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          -- command = "/home/michael/.local/share/nvim/mason/bin/codelldb",
          -- command = "C:\\Users\\Michael\\.vscode\\extensions\\vadimcn.vscode-lldb-1.11.0\\adapter\\codelldb.exe",
          args = { "--port", "${port}" },
          -- detached = false, -- On windows you may have to uncomment this:
        },
      }

      dap.adapters.cppdbg = {
        type = "executable",
        id = "cppdbg",
        command = "OpenDebugAD7",
        -- command = "/home/michael/.local/share/nvim/mason/bin/OpenDebugAD7",
        -- command = "C:\\Users\\Michael\\.vscode\\extensions\\ms-vscode.cpptools-1.21.6-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe",
        -- options = {
        -- detached = false, -- On windows you may have to uncomment this:
        -- },
      }

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }

      local config = {
        {
          name = "cppdbg launch (telescope)",
          type = "cppdbg",
          request = "launch",
          cwd = function()
            return vim.fn.expand("%:p:h") -- current file directory
          end,
          stopAtEntry = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
          program = telescope_pick,
        },
        {
          name = "cppdbg launch",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = function()
            return vim.fn.expand("%:p:h") -- current file directory
          end,
          stopAtEntry = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        {
          name = "cppdbg attach to gdbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/gdb",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
        },
        {
          name = "gdb launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "codelldb launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
      }

      dap.configurations.cpp = config
      dap.configurations.c = config
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ reset = true }) end, desc = "Debug: Toggle Dap UI" },
      { "<leader>dv", function() require("dapui").toggle({ layout = 1 }) end, desc = "Debug: Dap Scope" },
      { "<leader>dc", function() require("dapui").toggle({ layout = 2 }) end, desc = "Debug: Dap Console" },
      { "<leader>dv", function() require("dapui").toggle({ layout = 3 }) end, desc = "Debug: Dap Watch Variable" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Debug: Eval", mode = {"n", "v"} },
    },
    opts = {
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.8 },
            { id = "breakpoints", size = 0.1 },
            { id = "stacks", size = 0.1 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "console", size = 1.0 },
          },
          position = "bottom",
          size = 10,
        },
        {
          elements = {
            { id = "watches", size = 1.0 },
          },
          position = "right",
          size = 40,
        },
        -- {
        --   elements = {
        --     { id = "repl", size = 1.0 },
        --   },
        --   position = "top",
        --   size = 10,
        -- },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      -- stylua: ignore start
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
      -- stylua: ignore end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {
      commented = false, -- prefix virtual text with comment string
      virt_text_pos = "eol",
    },
  },
}
