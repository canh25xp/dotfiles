-- Using // comments instead of /* comments */
vim.bo.commentstring = "// %s"

-- Disable inserting comment leader after inset newline by pressing 'o', 'O', or '<Enter>'
vim.opt.formatoptions:remove("o")
vim.opt.formatoptions:remove("r")

-- Compile and run C++ code
local function compile_run_cpp()
  local file_path = vim.fn.expand("%") -- Full path to the current file
  local file_name_noext = vim.fn.expand("%:r") -- Full path to the file with out extension
  local executable = file_name_noext .. ".exe"
  local flags = "-Wall -Wextra -std=c++11 -O2"

  local compiler = ""
  if vim.fn.executable("clang++") == 1 then
    compiler = "clang++"
  elseif vim.fn.executable("g++") == 1 then
    compiler = "g++"
  else
    vim.notify("No C++ compiler found on the system", vim.log.levels.ERROR)
    return
  end

  -- BUG: Did not tested for cross platformm expecting bugs
  local cmd = string.format("%s %s %s -o %s && %s", compiler, flags, file_path, executable, executable)

  print(cmd)

  vim.cmd("split | term " .. cmd)

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>cc", compile_run_cpp, { buffer = true, noremap = true, silent = true, desc = "Compile run cpp" })
