return {
  "lervag/vimtex",
  lazy = false, -- lazy-loading will disable inverse search
  cond = function() return vim.fn.executable("latexmk") == 1 end,
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
      continuous = 1,
    }
    vim.g.vimtex_syntax_conceal = {
      accents = 0,
      ligatures = 0,
      cites = 1,
      fancy = 1,
      spacing = 1,
      greek = 1,
      math_bounds = 0,
      math_delimiters = 0,
      math_fracs = 0,
      math_super_sub = 0,
      math_symbols = 0,
      sections = 1,
      styles = 0,
    }
    vim.g.vimtex_quickfix_mode = 0
    -- vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
    -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
    vim.g.vimtex_view_enabled = 1
    vim.g.vimtex_view_automatic = 1
    vim.g.vimtex_doc_confirm_single = 0
    vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }

    if vim.g.is_wsl then
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_view_sioyek_options = "--reuse-window"
      vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
      vim.g.vimtex_callback_progpath = "wsl nvim"
    else
      vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"
      vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
    end

    -- vim.g.vimtex_callback_progpath = "pwsh"
    -- if vim.fn.has("win32") or (vim.fn.has("unix") and vim.fn.exists("$WSLENV")) then
    --   if vim.fn.executable("sioyek.exe") then
    --     vim.g.vimtex_view_method = "sioyek"
    --     vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
    --     vim.g.vimtex_callback_progpath = "wsl nvim"
    --   elseif vim.fn.executable("mupdf.exe") then
    --     vim.g.vimtex_view_general_viewer = "mupdf.exe"
    --   elseif vim.fn.executable("SumatraPDF.exe") then
    --     vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"
    --     vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
    --   end
    -- end
  end,
  keys = {
    { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true, ft = "tex"},
  },
}
