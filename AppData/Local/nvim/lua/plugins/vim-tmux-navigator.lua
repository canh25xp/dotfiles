return {
  "christoomey/vim-tmux-navigator",
  enabled = true,
  cond = not vim.g.is_windows,
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_disable_when_zoomed = 0
    vim.g.tmux_navigator_preserve_zoom = 1
    vim.g.tmux_navigator_no_wrap = 0
  end,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
    -- { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
  },
}
