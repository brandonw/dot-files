-- https://github.com/mfussenegger/nvim-lint#available-linters

local lint = require('lint')

lint.linters_by_ft = {
  javascript = {'eslint'},
  typescript = {'eslint'},
  -- curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.64.5
  go = {'golangcilint'},
}
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
