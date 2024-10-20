-- See https://github.com/neovim/nvim-lspconfig
-- Also update _config/nvim/lua/plugins/completion.lua

-- Setup language servers.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- npm install -g typescript-language-server typescript
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    }
  }
})

-- npm install -g vscode-langservers-extracted
lspconfig.jsonls.setup({
  capabilities = capabilities,
  settings = {
    json = {
      -- Disable builtin schemastore support in favor of b0o/SchemaStore.nvim
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    }
  }
})

-- npm install -g yaml-language-server
lspconfig.yamlls.setup({
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = {
        -- Disable builtin schemastore support in favor of b0o/SchemaStore.nvim
        enable = false,
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
    }
  }
})
