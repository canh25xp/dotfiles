return {
  "mikavilpas/yazi.nvim",
  cond = false,
  dependencies = { "folke/snacks.nvim", lazy = true },
  event = "VeryLazy",
  keys = {
    { "<leader>e", "<cmd>Yazi<cr>", desc = "Open Explorer" },
    { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open Explorer (cwd)" },
    { "<C-up>", "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session" },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    floating_window_scaling_factor = 1,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
