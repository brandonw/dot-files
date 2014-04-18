" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Required by vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle [required]
Bundle 'gmarik/vundle'

filetype plugin indent on

Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdcommenter'
Bundle 'bling/vim-airline'
Bundle 'mbbill/undotree'
Bundle 'majutsushi/tagbar'
Bundle 'tpope/vim-repeat'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'gregsexton/gitv'
Bundle 'eagletmt/ghcmod-vim'
Bundle 'bitc/lushtags'
Bundle 'scrooloose/syntastic'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'Valloric/YouCompleteMe'
Bundle 'rking/ag.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'kien/ctrlp.vim'
Bundle 'wting/rust.vim'
Bundle 'a.vim'
Bundle 'cscope_macros.vim'

" Avoid duplicate auto commands when writing .vimrc
autocmd!

" enable matchit.vim that is included with vim
runtime macros/matchit.vim

set backspace=indent,eol,start
set history=1000
set ruler
set showcmd
set incsearch
set nobackup
set ignorecase
set smartcase
set title
set scrolloff=10
set shortmess=atI
set autoindent
set t_Co=256
set hidden
set tags+=tags;$HOME
set laststatus=2
set wildmenu
set colorcolumn=+1
set completeopt=menuone,longest,preview
set rnu
set nu
set background=dark

let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:undotree_SplitWidth = 40
let g:ycm_collect_identifiers_from_tags_files = 1
let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
let g:UltiSnipsListSnippets = "<C-e>"
let g:solarized_diffmode = "high"
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['c'],
                           \ 'passive_filetypes': [] }
let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds'     : [
        \ 'f:functions',
        \ 'T:type definitions',
        \ 'g:enumeration names',
        \ 's:structure names',
        \ 'm:module names',
        \ 'c:static constants',
        \ 't:traits',
        \ 'i:trait implementations',
        \ 'd:macro definitions'
    \ ],
    \ 'sro'       : '::'
    \  }

syntax on
colorscheme solarized

nm <SPACE> :
nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l

nn <silent> <Leader>f :CtrlP<CR>
nn <silent> <Leader>b :CtrlPBuffer<CR>
nn <silent> <Leader>m :CtrlPMRU<CR>
nn <silent> <F9> :TagbarOpenAutoClose<CR>
nn <silent> <F5> :UndotreeToggle<CR>
nn <silent> <Leader>a :A<CR>
nn <Leader>t= :Tabularize /[^=]\+\zs=\(=\)\@!<CR>
vn <Leader>t= :Tabularize /[^=]\+\zs=\(=\)\@!<CR>

" Open file bindings
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>

cmap w!! %!sudo tee > /dev/null %

if has("gui_running")
  set guifont=Dina
  set guioptions-=T
  set guioptions-=m
  set lines=60
endif

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  au FileType text setlocal tw=79
  au FileType html,xml setlocal et ai tw=79 ts=4 sts=4 sw=4 fdm=syntax
  au FileType python setlocal et tw=79 ts=4 sts=4 sw=4 ai sr fdm=indent foldlevel=99
  au FileType rust setlocal et tw=100 ts=4 sts=4 sw=4 fdm=syntax
  au FileType gitcommit hi def link gitcommitOverflow Error
  au FileType gitcommit setlocal spell
  au FileWritePre,FileAppendPre,BufWritePre  * :call TrimWhiteSpace()
  au FileType c setlocal textwidth=80 formatoptions+=t
  au FileType haskell setlocal textwidth=80 ts=4 sw=4 et
else

endif " has("autocmd")
