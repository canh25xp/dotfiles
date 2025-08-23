local uv = vim.uv or vim.loop
local executable = require("common.utils").executable
local inspect = vim.inspect
local ok = vim.health.ok
local info = vim.health.info
local warn = vim.health.warn
local error = vim.health.error
local start = vim.health.start

local note = [[ NOTE: Not every warning is a 'must-fix' in `:checkhealth`
  Fix only warnings for plugins and languages you intend to use.
  Mason will give warnings for languages that are not installed.
  You do not need to install, unless you want to use those languages! ]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), "0.10-dev") then
    ok(string.format("Neovim version is: '%s'", verstr))
  else
    error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  local reqs = vim.g.is_windows and {
    "git",
    "lazygit",
    "python",
    "mingw32-make",
    "7z",
    "rg",
    "fd",
    "fzf",
  } or {
    "git",
    "lazygit",
    "python3",
    "make",
    "unzip",
    "rg",
    "fd",
    "fzf",
  }

  local servers = {
    "ruff",
    "pyright",
    "clangd",
    "texlab",
    "jdtls",
    "taplo",
    "marksman",
    "lua-language-server",
    "yaml-language-server",
    "vscode-json-language-server",
    "vscode-css-language-server",
    "vscode-html-language-server",
  }

  for _, exe in ipairs(reqs) do
    if executable(exe) then
      ok(string.format("Found executable: `%s`", exe))
    else
      warn(string.format("Could not find executable: `%s`", exe))
    end
  end

  for _, exe in ipairs(servers) do
    if executable(exe) then
      ok(string.format("Found language server: `%s`", exe))
    else
      warn(string.format("Could not find language server: `%s`", exe))
    end
  end

  return true
end

return {
  check = function()
    start("kickstart.nvim")

    info(note)

    info("System Information: " .. inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
