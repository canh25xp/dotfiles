return {
  "nat-418/boole.nvim",
  enabled = true,
  opts = {
    mappings = {
      increment = "<C-a>",
      decrement = "<C-x>",
    },
    additions = {
      { "Foo", "Bar" },
      { "tic", "tac", "toe" },
    },
  },
  config = function(_, opts)
    require("boole").setup(opts)
  end,
}
