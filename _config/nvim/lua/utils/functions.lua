-- Exported functions
local M = {}

local rg_prefix = 'grep! --fixed-strings --no-fixed-strings --no-ignore --ignore --ignore-case --case-sensitive '

M.searchAll = function ()
  local command = (rg_prefix
    .. M.getCurrentWord()
  )
  vim.fn.execute(command)
  vim.fn.histadd("cmd", command)
end

M.searchProd = function ()
  local command = (rg_prefix
    .. M.getCurrentWord()
    .. " -g !tests"
    .. " -g !test"
    .. " -g !\\*.test.js"
    .. " -g !\\*.test.js.snap"
    .. " -g !\\*.test.ts"
    .. " -g !\\*.test.ts.snap"
    .. " -g !@types/zapatos/index.d.ts"
    .. " -g !packages/backend/core/server/graphql"
    .. " -g !packages/app/src/graphql"
    .. " -g !\\*.sql"
    .. " -g !packages/backend/core/hasura"
  )
  vim.fn.execute(command)
  vim.fn.histadd("cmd", command)
end

M.getCurrentWord = function ()
  return vim.fn.shellescape(vim.fn.expand("<cword>"))
end

return M
