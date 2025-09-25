return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  cond = not vim.g.is_windows,
  opts = function()
    local logo = require("common.ui").logo
    logo = string.rep("\n", 8) .. logo .. "\n\n"
    local header = vim.split(logo, "\n")
    local opts = {
      theme = "doom",
      hide = {
        statusline = false, -- this is taken care of by lualine, enabling this messes up the actual laststatus setting after loading a file
      },
      config = {
        header = header,
        -- stylua: ignore
        center = {
          { action = "Telescope find_files",                                desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",                                   desc = " New File",        icon = " ", key = "n" },
          { action = "Neotree position=current",                            desc = " Neotree",         icon = " ", key = "e" },
          { action = 'lua require("persistence").load()',                   desc = " Restore Session", icon = " ", key = "r" },
          { action = "Lazy",                                                desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = require("common.utils").pick_chezmoi,                  desc = " Chezmoi",         icon = " ", key = "c", },
          { action = function() require("common.utils").LazyGit() end,      desc = " Lazygit",         icon = " ", key = "g" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end,      desc = " Quit",            icon = " ", key = "q" },
        },
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
