return {
  "MaximilianLloyd/ascii.nvim",
  enabled = false,
  lazy = true,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>sa",
      function()
        require("telescope").extensions.ascii.ascii()
      end,
      desc = "Ascii Preview",
    },
  },
  config = function()
    require("telescope").load_extension("ascii")
  end,
}
