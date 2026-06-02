local utils = require("utils.functions")
local keymap = vim.keymap.set

keymap("", "<Space>", ":")

keymap("n", "<C-S-h>", ":leftabove vsplit<CR>", { noremap = true })
keymap("n", "<C-S-l>", ":rightbelow vsplit<CR>", { noremap = true })

keymap("n", "get", ':tabnew <C-R>=expand("%:p:~:.:h") . "/" <CR>')
keymap("n", "gsa", utils.searchAll)
keymap("n", "gsp", utils.searchProd)
keymap("n", "yoh", ":nohlsearch<CR>")
keymap("n", "gcf", ':let @+ = expand("%:p:~:.")<CR>', { noremap = true })
keymap("n", "gfj", ":%!python3 -m json.tool<CR>")
keymap("v", "gfj", ":!python3 -m json.tool<CR>")
keymap("n", "gss", ":tabnew | terminal npm run dev api<CR>")
keymap("n", "gsr", ":tabnew | terminal npm run app<CR>:tabnew<CR>:terminal npm run dev worker<CR>:tabnew<CR>:terminal npm run dev scheduler<CR>:tabnew<CR>:terminal npm run dev customer-data-worker<CR>")
keymap("n", "gsc", ":tabnew | terminal claude --dangerously-skip-permissions<CR>")
keymap("n", "[b", ":bprevious<CR>")
keymap("n", "]b", ":bnext<CR>")
keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<Leader>dq", vim.diagnostic.setloclist)
keymap("", "<F2>", ":mksession! ~/.nvim_session<CR>")
keymap("", "<F3>", ":source ~/.nvim_session<CR>")
keymap("", "<F5>", ":e!<CR>")

keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true})
keymap("t", "<C-v><Esc>", "<Esc>", { noremap = true})

-- keymap("c", "bd", "lua Snacks.bufdelete()")
