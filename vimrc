filetype off
set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
Plug 'brandonw/vim-colors-solarized'
Plug 'hashivim/vim-terraform'
Plug 'gregsexton/gitv'
" Plug 'haorenW1025/diagnostic-nvim'
Plug 'justinmk/vim-dirvish'
Plug 'lambdalisue/suda.vim'
Plug 'mbbill/undotree'
Plug 'neomake/neomake'
Plug 'neovim/nvim-lsp'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/closetag.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

filetype plugin indent on

" enable matchit.vim that is included with vim
runtime macros/matchit.vim

set clipboard+=unnamedplus
set colorcolumn=+1
set completeopt=menuone,longest,preview
set diffopt=filler,vertical,internal,indent-heuristic,algorithm:histogram
set dir=~/.swap
set hidden
set inccommand=nosplit
set mouse=a
set nohlsearch
set noautoread
set number
set path=.,**
set relativenumber
" set scrolloff=5
set shortmess=atIc
set signcolumn=yes
set switchbuf+=newtab " test this
set termguicolors
set title

syntax on
colorscheme solarized

let mapleader="\\"
let g:undotree_SplitWidth = 40
let g:solarized_diffmode = "high" " high, low, normal
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.readonly = 'RO'
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'paste'
let g:airline_symbols.spell = 'spell'
let g:airline_symbols.notexists = 'a'
let g:airline_symbols.whitespace = '-'
let g:airline_symbols.colnr = '-'
let g:airline#extensions#whitespace#checks = ['indent', 'trailing', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#trailing_format = ' trailing:[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = ' mixed-indent:[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format = ' mix-indent-file:[%s]'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline_exclude_preview = 1
" https://github.com/haorenW1025/diagnostic-nvim
" let g:diagnostic_insert_delay = 1
" let g:diagnostic_enable_virtual_text = 1
" let g:diagnostic_virtual_text_prefix = ' '
" call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
" call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
" call sign_define("LspDiagnosticInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
" call sign_define("LspDiagnosticHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})
" https://github.com/haorenW1025/completion-nvim

let g:airline_section_c = '%<%<%{airline#extensions#fugitiveline#bufname()}%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#neomake#get_warnings(),0)}%{airline#util#wrap(airline#extensions#whitespace#check(),0)}%'
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#whitespace#check(),0)}%'

let g:neomake_list_height = 15
let g:neomake_error_sign = {
    \   'text': 'X',
    \   'texthl': 'airline_error',
    \ }
let g:neomake_warning_sign = {
    \   'text': '!',
    \   'texthl': 'DiffChange',
    \ }
let g:neomake_message_sign = {
    \   'text': '>',
    \   'texthl': 'StatusLine',
    \ }
let g:neomake_info_sign = {
    \   'text': 'i',
    \   'texthl': 'helpExample',
    \ }
let g:neomake_javascript_eslint_exe = substitute(system('npm bin'), '\n\+$', '', '') . '/eslint'
let g:javascript_plugin_jsdoc = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1

noremap <space> :
nnoremap gob :ls<CR>:b<Space>
nnoremap gof :FZF<CR>
nnoremap goe :Dirvish<CR>
nnoremap <F5> :UndotreeToggle<cr>
nnoremap gwn <C-W><C-W>
vnoremap gwn <C-W><C-W>
nnoremap gwp <C-W>W
vnoremap gwp <C-W>W
nnoremap gwh <C-W>h
vnoremap gwh <C-W>h
nnoremap gwj <C-W>j
vnoremap gwj <C-W>j
nnoremap gwk <C-W>k
vnoremap gwk <C-W>k
nnoremap gwl <C-W>l
vnoremap gwl <C-W>l
nnoremap gew :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap gsa :let cmd="silent grep! " . GetCurrentWord() <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nnoremap gsp :let cmd="silent grep! " . GetCurrentWord() . " --iglob !tests --iglob !test --iglob !\\*.test.js --iglob !\\*.test.js.snap" <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nnoremap gcf :let @+ = expand("%")<CR>
nnoremap gfj :%!python -m json.tool<CR>
vnoremap gfj :!python -m json.tool<CR>
nnoremap gfh :%!prettier --parser html<CR>
vnoremap gfh :!prettier --parser html<CR>
nnoremap gfd :Gvdiffsplit
nnoremap gsd :lwindow<CR>
map <F2> :mksession! ~/.vim/vim_session<cr>
map <F3> :source ~/.vim/vim_session<cr>

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : deoplete#manual_complete()
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

let g:suda#prompt = '[sudo] password for brandon: '
cmap w!! w suda://%

if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ $*
  set grepformat=%f:%l:%c:%m
endif


function! GetCurrentWord()
  return shellescape(expand("<cword>"))
endfunction

function! TrimWhiteSpace()
    let b:view = winsaveview()
    %s/\s\+$//e
    call winrestview(b:view)
endfunction

" LSP
" pacman -S javascript-typescript-langserver
" lua << EOF

" local nvim_lsp = require'nvim_lsp'
" local configs = require'nvim_lsp/configs'
" -- Check if it's already defined for when I reload this file.
" if not configs.js_ts_langserver then
"   configs.js_ts_langserver = {
"     default_config = {
"       cmd = {'javascript-typescript-stdio'};
"       filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' };
"       root_dir = nvim_lsp.util.root_pattern('package.json', 'tsconfig.json', '.git');
"       settings = {};
"     };
"   }
" end
" nvim_lsp.js_ts_langserver.setup{on_attach=require'diagnostic'.on_attach}

" EOF

" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" AutoCommands
augroup vimrcEx
  autocmd!
  autocmd BufRead,BufNewFile *.snyk   setfiletype yaml
  autocmd BufRead,BufNewFile Vagrantfile set ft=ruby
  autocmd BufWritePost * Neomake
  autocmd FileType gitcommit hi def link gitcommitOverflow Error
  autocmd FileWritePre,FileAppendPre,BufWritePre  * :call TrimWhiteSpace()
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
  autocmd QuickFixCmdPost *grep* cwindow
  autocmd TermOpen * setlocal nonumber norelativenumber
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)

  if v:version >= 700 && !&diff
      autocmd BufEnter,BufRead * if exists("b:view") | call winrestview(b:view) | endif
      autocmd BufLeave,BufReadPre * let b:view = winsaveview()
  endif

  autocmd FileType text                setlocal tw=80
  autocmd FileType sh                  setlocal et ai tw=80 ts=4 sw=4
  autocmd FileType html,xml,htmldjango setlocal et ai tw=0 ts=4 sw=4 fdm=syntax
  autocmd FileType mkd                 setlocal et ai tw=80 ts=4 sw=4 cc=+1
  autocmd FileType md,tex              setlocal et ai tw=80 ts=4 sw=4 cc=+1
  autocmd FileType css,sass,scss       setlocal et ai tw=80 ts=2 sw=2
  autocmd FileType javascript          setlocal et tw=120 ts=4 sw=4 ai sr fdm=indent foldlevel=99 omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType json,pug,xml        setlocal et tw=100 ts=2 sw=2 ai sr fdm=indent foldlevel=99
  autocmd FileType yaml                setlocal et tw=100 ts=2 sw=2 ai sr
  autocmd FileType python              setlocal et tw=100 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType sql                 setlocal et tw=80 ts=4 sw=4 ai
  autocmd FileType groovy              setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType ruby                setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType rust                setlocal et tw=100 ts=4 sw=4
  autocmd FileType cs                  setlocal et tw=100 ts=4 sw=4
  autocmd FileType c                   setlocal textwidth=80 formatoptions+=t
  autocmd FileType haskell             setlocal textwidth=80 ts=4 sw=4 et
  autocmd FileType gitcommit           setlocal spell

  " Abbreviations
  autocmd FileType javascript :iabbr dl# console.log('---TEST---');<CR>console.log(JSON.stringify(foo));
augroup END
