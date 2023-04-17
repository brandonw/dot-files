-- Exported functions
local M = {}

M.searchAll = function ()
  local command = "grep! " .. M.getCurrentWord()
  vim.fn.execute(command)
  vim.fn.histadd("cmd", command)
end

M.searchProd = function ()
  local command = "grep! " .. M.getCurrentWord() .. " --iglob !tests --iglob !test --iglob !\\*.test.js --iglob !\\*.test.js.snap"
  vim.fn.execute(command)
  vim.fn.histadd("cmd", command)
end

M.getCurrentWord = function ()
  return vim.fn.shellescape(vim.fn.expand("<cword>"))
end

M.trimWhiteSpace = function ()
  local view = vim.fn.winsaveview()
  vim.cmd("%s/\\s\\+$//e")
  vim.fn.winrestview(view)
end

return M
