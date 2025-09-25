return {
  on_init = function(client)
    client.config.settings.json = vim.tbl_deep_extend("force", client.config.settings.json, {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    })
  end,
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
    },
  },
}
