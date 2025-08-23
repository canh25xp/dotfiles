return {
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    -- va)  - [V]isually select [A]round [)]paren
    -- yinq - [Y]ank [I]nside [N]ext [Q]uote
    -- ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- sd'   - [S]urround [D]elete [']quotes
    -- sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    -- Autopairs
    require("mini.pairs").setup()

    require("mini.indentscope").setup({
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
      },

      options = {
        indent_at_cursor = false,
      },
      symbol = "",
    })


    require("mini.bufremove").setup()
    vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete Current Buffer" })
    vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Wipeout Current Buffer" })
  end,
}
