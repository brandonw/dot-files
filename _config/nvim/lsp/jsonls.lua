return {
  settings = {
    json = {
      -- Disable builtin schemastore support in favor of b0o/SchemaStore.nvim
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    }
  },
}
