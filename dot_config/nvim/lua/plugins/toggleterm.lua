return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  keys = {
    { "<C-\\>" },
    { "<leader>t1", "<Cmd>1ToggleTerm<Cr>", desc = "Terminal #1" },
    { "<leader>t2", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    { "<leader>tt", "<Cmd>ToggleTerm direction=tab<Cr>", desc = "ToggleTerm in new tab" },
    { "<leader>t-", "<Cmd>ToggleTerm direction=horizontal<Cr>", desc = "ToggleTerm horizontal split" },
    { "<leader>t\\", "<Cmd>ToggleTerm direction=vertical<Cr>", desc = "ToggleTerm vertical split" },
    { "<leader>gg", "<cmd>lua _LazygitToggle()<CR>", desc = "Lazygit" },
    { "<leader>gl", "<cmd>lua _LazygitLogToggle()<CR>", desc = "Lazygit Log" },
    { "<leader>bt", "<cmd>lua _BottomToggle()<CR>", desc = "Bottom" },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.5
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    close_on_exit = true,
    float_opts = {
      title_pos = "center",
      border = "curved",
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm*", -- "term://*" to apply for all terminal
      desc = "toggleterm keymap",
      callback = function()
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], { buffer = 0 })
        vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { buffer = 0 })
        vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<cr>]], { buffer = 0, desc = "Focus left" })
        vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<cr>]], { buffer = 0, desc = "Focus right" })
        vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<cr>]], { buffer = 0, desc = "Focus lower" })
        vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<cr>]], { buffer = 0, desc = "Focus upper" })
        -- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0 })
      end,
    })
    require("toggleterm").setup(opts)
    local lazygit = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      hidden = true,
      direction = "tab",
      display_name = "Lazygit",
      on_create = function(term)
        local bn = term.bufnr
        vim.api.nvim_buf_set_keymap(bn, "t", "<C-\\>", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_del_keymap(bn, "t", "jk")
        vim.api.nvim_buf_del_keymap(bn, "t", "<esc><esc>")
      end,
    })
    local lazygit_log = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit log",
      dir = "git_dir",
      hidden = true,
      direction = "tab",
      display_name = "Lazygit Log",
      on_create = function(term)
        local bn = term.bufnr
        vim.api.nvim_buf_set_keymap(bn, "t", "<C-\\>", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_del_keymap(bn, "t", "jk")
        vim.api.nvim_buf_del_keymap(bn, "t", "<esc><esc>")
      end,
    })
    local btm = require("toggleterm.terminal").Terminal:new({
      cmd = "btm",
      hidden = true,
      direction = "tab",
      display_name = "btm",
      on_create = function(term)
        local bn = term.bufnr
        vim.api.nvim_buf_set_keymap(bn, "t", "<C-\\>", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_del_keymap(bn, "t", "jk")
        vim.api.nvim_buf_del_keymap(bn, "t", "<esc><esc>")
      end,
    })
    function _LazygitLogToggle()
      lazygit_log:toggle()
    end
    function _LazygitToggle()
      lazygit:toggle()
    end
    function _BottomToggle()
      btm:toggle()
    end
  end,
}
