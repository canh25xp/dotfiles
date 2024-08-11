return {
  "MaximilianLloyd/ascii.nvim",
  enabled = true,
  lazy = true,
  keys = {
    {
      "<leader>a",
      function()
        require("ascii").preview()
      end,
      desc = "Ascii Preview",
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
}
