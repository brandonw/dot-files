-- See https://github.com/neovim/nvim-lspconfig
-- Also update _config/nvim/lua/plugins/cmp.lua

-- Setup language servers.
local lspconfig = require('lspconfig')

-- Per npm install:
-- npm install -g typescript-language-server typescript
lspconfig.tsserver.setup({
  init_options = {
    preferences = {
      disableSuggestions = true,
    }
  }
})
