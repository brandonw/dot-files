local autocmd = vim.api.nvim_create_autocmd

---- general
autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.snyk"},
  command = "setfiletype yaml",
})

autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*/kubernetes/*.yaml"},
  command = "setlocal filetype=helm",
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
  command = "setlocal textwidth=80",
})

autocmd({"FileType"}, {
  pattern = {"sh"},
  command = "setlocal et autoindent textwidth=80 tabstop=4 shiftwidth=4",
})

autocmd({"FileType"}, {
  pattern = {"html", "xml"},
  command = "setlocal et autoindent textwidth=0 tabstop=4 shiftwidth=4 fdm=syntax",
})

autocmd({"FileType"}, {
  pattern = {"mkd", "md", "tex"},
  command = "setlocal et autoindent textwidth=80 tabstop=4 shiftwidth=4 cc=+1",
})

autocmd({"FileType"}, {
  pattern = {"css", "sass", "scss"},
  command = "setlocal et autoindent textwidth=80 tabstop=2 shiftwidth=2",
})

autocmd({"FileType"}, {
  pattern = {"javascript"},
  command = "setlocal et textwidth=120 tabstop=2 shiftwidth=2 autoindent shiftround fdm=indent foldlevel=99 omnifunc=v:lua.vim.lsp.omnifunc",
})
autocmd({"FileType"}, {
  pattern = {"typescript"},
  command = "setlocal et textwidth=120 tabstop=2 shiftwidth=2 autoindent shiftround fdm=indent foldlevel=99 omnifunc=v:lua.vim.lsp.omnifunc",
})
autocmd({"FileType"}, {
  pattern = {"typescriptreact"},
  command = "setlocal et textwidth=120 tabstop=2 shiftwidth=2 autoindent shiftround fdm=indent foldlevel=99 omnifunc=v:lua.vim.lsp.omnifunc",
})
autocmd({"FileType"}, {
  pattern = {"javascript", "typescript"},
  command = ":iabbr dl# console.log('---TEST---');<CR>console.log(JSON.stringify(foo));",
})

autocmd({"FileType"}, {
  pattern = {"json", "jsonc", "pug", "xml"},
  command = "setlocal et textwidth=100 tabstop=2 shiftwidth=2 autoindent shiftround fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"yaml", "helm"},
  command = "setlocal et textwidth=100 tabstop=2 shiftwidth=2 autoindent shiftround",
})

autocmd({"FileType"}, {
  pattern = {"python"},
  command = "setlocal et textwidth=100 tabstop=4 shiftwidth=4 autoindent shiftround fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"sql"},
  command = "setlocal et textwidth=80 tabstop=4 shiftwidth=4 autoindent",
})

autocmd({"FileType"}, {
  pattern = {"ruby"},
  command = "setlocal et textwidth=80 tabstop=4 shiftwidth=4 autoindent shiftround fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"lua"},
  command = "setlocal et textwidth=80 tabstop=2 shiftwidth=2 autoindent shiftround fdm=indent foldlevel=99",
})

autocmd({"FileType"}, {
  pattern = {"cs"},
  command = "setlocal et textwidth=100 tabstop=4 shiftwidth=4",
})

autocmd({"FileType"}, {
  pattern = {"c"},
  command = "setlocal textwidth=80 formatoptions+=t",
})

autocmd({"FileType"}, {
  pattern = {"go"},
  command = "setlocal textwidth=120 tabstop=4 shiftwidth=4 noexpandtab formatoptions+=t",
})

autocmd({"FileType"}, {
  pattern = {"gitcommit"},
  command = "setlocal spell",
})

--------------------------------------
-- language server protocol keymaps --
--------------------------------------
autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    -- conform owns formatting and can fallback to lsp as needed
    -- vim.keymap.set('n', '<Leader>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
