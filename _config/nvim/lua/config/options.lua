vim.g.mapleader = "\\"

vim.opt.autoread = false
vim.opt.clipboard:append { "unnamedplus" }
vim.opt.colorcolumn = { "+1" }
vim.opt.completeopt = { "menuone", "longest", "preview" }
vim.opt.diffopt = { "filler", "vertical", "internal", "indent-heuristic", "algorithm:histogram", "iwhite" }
vim.opt.foldenable = false
-- vim.opt.foldmethod = "indent"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.hlsearch = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess = "atIc"
vim.opt.signcolumn = "number"
vim.opt.switchbuf = "newtab"
vim.opt.termguicolors = true
vim.opt.title = true

if vim.fn.executable('rg') == 1 then
  vim.opt.grepformat="%f:%l:%c:%m"
  vim.opt.grepprg="rg --vimgrep --hidden $*"
end
