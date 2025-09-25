return {
  "ibhagwan/fzf-lua",
  enabled = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    winopts = {
      width = 0.9,
      height = 0.9,
      row = 0.5,
      col = 0.5,
    },
  },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
  end,
}
