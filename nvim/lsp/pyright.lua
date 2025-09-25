return {
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff's import organizer
    },
    python = {
      analysis = {
        -- TODO: onlny ignore if ruff is attached
        ignore = { "*" }, -- Ignore all files for analysis to exclusively use Ruff for linting
      },
    },
  },
}
