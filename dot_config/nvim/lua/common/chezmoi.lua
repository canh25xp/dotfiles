local M = {}

M.config = {
  watch = false, -- Update on save or change
}

function M.execute_template()
  local input_buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(input_buf):gsub("%.tmpl$", "")
  local filetype = vim.filetype.match({ filename = filename })

  local input_lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
  local input = table.concat(input_lines, "\n")

  local output = vim.fn.systemlist("chezmoi execute-template", input)
  if vim.v.shell_error ~= 0 then
    vim.notify("chezmoi execute-template failed", vim.log.levels.ERROR)
    return
  end

  local current_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  local new_win = vim.api.nvim_get_current_win()
  local output_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(new_win, output_buf)
  vim.api.nvim_set_current_win(current_win)

  local input_name = vim.api.nvim_buf_get_name(input_buf)
  vim.api.nvim_buf_set_name(output_buf, "ChezmoiOutput://" .. input_name)
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, output)

  vim.bo[output_buf].buftype = "nofile"
  vim.bo[output_buf].bufhidden = "wipe"
  vim.bo[output_buf].swapfile = false
  vim.bo[output_buf].modifiable = false

  if filetype then
    vim.bo[output_buf].filetype = filetype
  else
    vim.bo[output_buf].filetype = "text" -- fallback
  end
end

-- Auto-update logic
function M.attach_autocmds()
  vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged" }, {
    pattern = "*.tmpl",
    callback = function()
      if M.config.watch then
        M.execute_template()
      end
    end,
    desc = "Auto-update chezmoi template output",
  })
end

-- Command setup
function M.setup(user_config)
  if user_config then
    M.config = vim.tbl_deep_extend("force", M.config, user_config)
  end

  vim.api.nvim_create_user_command("ChezmoiExecute", function()
    M.execute_template()
  end, { desc = "Execute current chezmoi template and show output" })

  vim.keymap.set("n", "<leader>ce", "<cmd>ChezmoiExecute<cr>", { desc = "Chezmoi execute template" })

  M.attach_autocmds()
end

return M
