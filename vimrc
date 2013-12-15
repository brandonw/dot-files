" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Required by vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle [required]
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdcommenter'
Bundle 'bling/vim-airline'

filetype plugin indent on

" Avoid duplicate auto commands when writing .vimrc
autocmd!

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
set hlsearch
set t_Co=256
set hidden
set laststatus=2
set wildmenu
set colorcolumn=+1
set completeopt=menuone,longest,preview
set rnu
set background=dark
syntax on
colorscheme solarized

let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'

nn <silent> <Leader>s :nohls<CR>
nm <SPACE> :
nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l

" Open file bindings
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>

cmap w!! %!sudo tee > /dev/null %

function TrimWhiteSpace()
    %s/\s\+$//e
:endfunction

if has("gui_running")
  set guifont=Dina
  set guioptions-=T
  set guioptions-=m
  set lines=60
endif

if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=79
  autocmd FileType gitcommit hi def link gitcommitOverflow Error
  autocmd FileType gitcommit setlocal spell
  autocmd FileWritePre,FileAppendPre,BufWritePre  * :call TrimWhiteSpace()
else

endif " has("autocmd")
