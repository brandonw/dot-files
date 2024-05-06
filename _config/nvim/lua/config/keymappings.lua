local utils = require("utils.functions")

local keymap = vim.keymap.set

keymap('', '<Space>', ':')
keymap('n', 'gwh', '<C-W>h')
keymap('n', 'gwj', '<C-W>j')
keymap('n', 'gwk', '<C-W>k')
keymap('n', 'gwl', '<C-W>l')
keymap("n", 'get', ':tabnew <C-R>=expand("%:h") . "/" <CR>')
keymap("n", 'gsa', utils.searchAll)
keymap("n", 'gsp', utils.searchProd)
keymap('n', 'gcf', ':let @+ = expand("%")<CR>')
keymap('n', 'gfj', ':%!python -m json.tool<CR>')
keymap('v', 'gfj', ':!python -m json.tool<CR>')
keymap('n', '[d', vim.diagnostic.goto_prev)
keymap('n', ']d', vim.diagnostic.goto_next)
keymap('n', '<Leader>dq', vim.diagnostic.setloclist)
keymap('', '<F2>', ':mksession! ~/.nvim_session<CR>')
keymap('', '<F3>', ':source ~/.nvim_session<CR>')
keymap('', '<F5>', ':e!<CR>')
