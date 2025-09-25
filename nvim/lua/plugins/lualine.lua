local ui = require("common.ui")
local utils = require("common.utils")
local icons = ui.icons

return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  opts = {
    options = {
      theme = "catppuccin",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    extensions = { "neo-tree", "lazy", "toggleterm", "mason", "nvim-dap-ui", "quickfix" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch" },
        {
          "diff",
          symbols = icons.git,
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },
      lualine_c = {
        { "filetype", padding = { left = 1, right = 0 }, separator = " ", icon_only = true },
        { "filename", padding = { left = 0, right = 1 } },
        { "lsp_status" },
        { "diagnostics", symbols = icons.diagnostics, separator = " ", cond = vim.diagnostic.is_enabled },
        { utils.get_diagnostic_status, color = { fg = "#ff9e64" } },
      },

      lualine_x = {
        { utils.macro_recording, color = { fg = "#ff9e64" }, separator = " " },
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
        },
      },
      lualine_y = {
        { "searchcount", separator = " ", padding = { left = 1, right = 0 } },
        { "selectioncount", separator = " ", padding = { left = 1, right = 0 } },
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = { "encoding", "filesize", "fileformat" },
    },
  },
}
