return {
  "luukvbaal/statuscol.nvim",
  enabled = false,
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      segments = {
        {
          sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, auto = true },
          click = "v:lua.ScSa",
        },
        {
          sign = { namespace = { "gitsigns" }, maxwidth = 1, auto = true },
          click = "v:lua.ScSa",
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
      },
      -- segments = {
      --   {
      --     text = { builtin.foldfunc },
      --     click = "v:lua.ScFa",
      --   },
      --   {
      --     sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
      --     click = "v:lua.ScSa",
      --   },
      --   {
      --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
      --     click = "v:lua.ScSa",
      --   },
      -- },
    })
  end,
}
