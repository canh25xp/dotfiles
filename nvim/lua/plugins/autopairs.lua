return {
  "windwp/nvim-autopairs",
  enabled = false,
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  opts = {},
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp") -- If you want to automatically add `(` after selecting a function or method
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    npairs.setup(opts)
  end,
}
