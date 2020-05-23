filetype off
set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
Plug 'SirVer/ultisnips'
Plug 'brandonw/vim-colors-solarized'
Plug 'gregsexton/gitv'
Plug 'honza/vim-snippets'
Plug 'justinmk/vim-dirvish'
Plug 'lambdalisue/suda.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mbbill/undotree'
Plug 'neomake/neomake'
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

" Language Server Protocol
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
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
set nohls
set number
set path=.,**
set relativenumber
" set scrolloff=5
set shortmess=atIc
" set signcolumn=yes
set switchbuf+=newtab " test this
set termguicolors
set title
" set updatetime=300

syntax on
colorscheme solarized

let mapleader="\\"
let g:undotree_SplitWidth = 40
let g:solarized_diffmode = "high" " high, low, normal
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '◀'
let g:airline_symbols.readonly = 'RO'
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'paste'
let g:airline_symbols.spell = 'spell'
" let g:airline_symbols.notexists = ' ∄'
" let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#whitespace#checks = ['indent', 'trailing', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#trailing_format = ' trailing:[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = ' mixed-indent:[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format = ' mix-indent-file:[%s]'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline_exclude_preview = 1

let g:airline_section_c = '%<%<%{airline#extensions#fugitiveline#bufname()}%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#neomake#get_warnings(),0)}%{airline#util#wrap(airline#extensions#whitespace#check(),0)}%'

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
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsListSnippets = "<F8>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ }
let g:LanguageClient_diagnosticsList = "v:null"
let g:LanguageClient_diagnosticsEnable = 0
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
nnoremap gsp :let cmd="silent grep! " . GetCurrentWord() . " --iglob !tests --iglob !test" <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nnoremap gcf :let @+ = expand("%")<CR>
nnoremap gfj :%!python -m json.tool<CR>
vnoremap gfj :!python -m json.tool<CR>
nnoremap gfd :Gvdiffsplit
nnoremap gsd :lwindow<CR>
map <F2> :mksession! ~/.vim/vim_session<cr>
map <F3> :source ~/.vim/vim_session<cr>
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : deoplete#manual_complete()
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

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

" go to defn of tag under the cursor
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('<cword>')
    finally
       let &ic = ic
    endtry
endfun
nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

augroup vimrcEx
  au!
  autocmd BufRead,BufNewFile *.snyk   setfiletype yaml
  autocmd QuickFixCmdPost *grep* cwindow
  autocmd FileType text                setlocal tw=80
  autocmd FileType sh                  setlocal et ai tw=80 ts=4 sw=4
  autocmd FileType html,xml,htmldjango setlocal et ai tw=0 ts=4 sw=4 fdm=syntax
  autocmd FileType mkd                 setlocal et ai tw=80 ts=4 sw=4 cc=+1
  autocmd FileType md,tex 	         setlocal et ai tw=80 ts=4 sw=4 cc=+1
  autocmd FileType css,sass,scss       setlocal et ai tw=80 ts=2 sw=2
  autocmd FileType javascript          setlocal et tw=120 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType json,pug,xml        setlocal et tw=100 ts=2 sw=2 ai sr fdm=indent foldlevel=99
  autocmd FileType yaml                setlocal et tw=100 ts=2 sw=2 ai sr
  autocmd FileType python              setlocal et tw=100 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType sql 		 setlocal et tw=80 ts=4 sw=4 ai
  autocmd FileType groovy 		 setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType ruby 		 setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  autocmd FileType rust 		 setlocal et tw=100 ts=4 sw=4
  autocmd FileType cs 		 setlocal et tw=100 ts=4 sw=4
  autocmd FileType c 			 setlocal textwidth=80 formatoptions+=t
  autocmd FileType haskell 		 setlocal textwidth=80 ts=4 sw=4 et
  autocmd FileType gitcommit 		 setlocal spell
  autocmd FileType gitcommit hi def link gitcommitOverflow Error
  autocmd FileWritePre,FileAppendPre,BufWritePre  * :call TrimWhiteSpace()
  autocmd BufRead,BufNewFile Vagrantfile set ft=ruby
  autocmd CmdwinEnter * let b:deoplete_sources = ['buffer']
  autocmd BufWritePost * Neomake
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
  if v:version >= 700 && !&diff
      autocmd BufEnter,BufRead * if exists("b:view") | call winrestview(b:view) | endif
      autocmd BufLeave,BufReadPre * let b:view = winsaveview()
  endif
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END
