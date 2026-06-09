local ts = require("nvim-treesitter")

-- Parsers we always want available. On the `main` branch this is no longer
-- `ensure_installed` in setup() -- you call install() explicitly.
local ensure_installed = {
  "lua",
  "vim",
  "vimdoc",
  "javascript",
  "typescript",
  "go",
  "markdown",
  "markdown_inline",
}
local ignore_filetypes = {
  qf = true,
}
ts.setup({})
ts.install(ensure_installed)

-- The `main` branch does not enable highlighting for you. Start treesitter
-- per-buffer on FileType. This also mimics `auto_install`: if a parser for the
-- current filetype isn't installed yet, install it and start once it's ready.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ignore_filetypes[ft] then
      return
    end

    local lang = vim.treesitter.language.get_lang(ft) or ft

    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf, lang)
    else
      -- parser not available locally -- install then start
      ts.install({ lang }):await(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          pcall(vim.treesitter.start, args.buf, lang)
        end
      end)
    end
  end,
})
