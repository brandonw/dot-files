vim.g.mapleader = "\\"

vim.opt.autoread = false
vim.opt.clipboard:append { "unnamedplus" }
vim.opt.colorcolumn = { "+1" }
vim.opt.completeopt = { "menuone", "longest", "preview" }
vim.opt.diffopt = { "filler", "vertical", "internal", "indent-heuristic", "algorithm:histogram", "iwhite" }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess = "atIc"
vim.opt.signcolumn = "number"
vim.opt.switchbuf = "newtab"
vim.opt.termguicolors = true
vim.opt.title = true

-- Default to treesitter folding
-- LSP autocmd overrides on attach if support is available
vim.opt.foldenable = false
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

if vim.fn.executable('rg') == 1 then
  vim.opt.grepformat="%f:%l:%c:%m"
  vim.opt.grepprg="rg --vimgrep --hidden $*"
end

vim.shadafile = "" -- default
local gitdir = vim.uv.cwd() .. "/.git"
if vim.uv.fs_stat(gitdir) then
  vim.opt.shadafile = ".shada"
end
