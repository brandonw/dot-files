return {
  settings = {
    yaml = {
      schemaStore = {
        -- Disable builtin schemastore support in favor of b0o/SchemaStore.nvim
        enable = false,
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
    }
  },
}
