local utils = require("utils.functions")

local autocmd = vim.api.nvim_create_autocmd

---- general
autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.snyk"},
  command = "setfiletype yaml",
})

autocmd({"QuickFixCmdPost"}, {
  pattern = {"*grep*"},
  command = "cwindow",
})

autocmd({"TextYankPost"}, {
  pattern = {"*"},
  callback = function ()
    vim.highlight.on_yank({higroup="IncSearch", timeout=1000})
  end,
})

-- if a file is changed externally, don't messages
autocmd({"FileChangedShell"}, {
  pattern = {"*"},
  callback = function () end,
})

---- filetype
autocmd({"FileType"}, {
  pattern = {"text"},
  command = "setlocal tw=80",
})

autocmd({"FileType"}, {
  pattern = {"sh"},
  command = "setlocal et ai tw=80 ts=4 sw=4",
})

autocmd({"FileType"}, {
  pattern = {"html", "xml"},
  command = "setlocal et ai tw=0 ts=4 sw=4 fdm=syntax",
})

autocmd({"FileType"}, {
  pattern = {"mkd", "md", "tex"},
  command = "setlocal et ai tw=80 ts=4 sw=4 cc=+1",
})

autocmd({"FileType"}, {
  pattern = {"css", "sass", "scss"},
  command = "setlocal et ai tw=80 ts=2 sw=2",
})

autocmd({"FileType"}, {
  pattern = {"javascript"},
  command = "setlocal et tw=120 ts=4 sw=4 ai sr fdm=indent foldlevel=99 omnifunc=v:lua.vim.lsp.omnifunc",
})
autocmd({"FileType"}, {
  pattern = {"typescript"},
  command = "setlocal et tw=120 ts=2 sw=2 ai sr fdm=indent foldlevel=99 omnifunc=v:lua.vim.lsp.omnifunc",
})
autocmd({"FileType"}, {
  pattern = {"javascript", "typescript"},
  command = ":iabbr dl# console.log('---TEST---');<CR>console.log(JSON.stringify(foo));",
})

autocmd({"FileType"}, {
  pattern = {"json", "pug", "xml"},
  command = "setlocal et tw=100 ts=2 sw=2 ai sr fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"yaml"},
  command = "setlocal et tw=100 ts=2 sw=2 ai sr",
})

autocmd({"FileType"}, {
  pattern = {"python"},
  command = "setlocal et tw=100 ts=4 sw=4 ai sr fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"sql"},
  command = "setlocal et tw=80 ts=4 sw=4 ai",
})

autocmd({"FileType"}, {
  pattern = {"ruby"},
  command = "setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"lua"},
  command = "setlocal et tw=80 ts=2 sw=2 ai sr fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"cs"},
  command = "setlocal et tw=100 ts=4 sw=4",
})

autocmd({"FileType"}, {
  pattern = {"c"},
  command = "setlocal textwidth=80 formatoptions+=t",
})

autocmd({"FileType"}, {
  pattern = {"gitcommit"},
  command = "setlocal spell",
})
