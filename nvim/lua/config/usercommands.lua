vim.api.nvim_create_user_command("RemoveCR", function()
  vim.cmd([[%s/\r//g]])
end, { desc = "Remove carriage return (^M)" })
