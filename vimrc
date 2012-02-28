" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Required by vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle [required]
Bundle 'gmarik/vundle'

" github bundles
Bundle 'int3/vim-extradite'
Bundle 'gregsexton/gitv'
Bundle 'tpope/vim-fugitive'
Bundle 'defunkt/gist'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'altercation/vim-colors-solarized'
Bundle 'sjbach/lusty'
Bundle 'wincent/Command-T'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-markdown'
Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/syntastic'
Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'docunext/closetag.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'msanders/snipmate.vim'
Bundle 'ervandew/supertab'
Bundle 'Rip-Rip/clang_complete'

" vim-scripts repos
Bundle 'a.vim'
Bundle 'cscope_macros.vim'
Bundle 'loremipsum'
Bundle 'Gundo'
Bundle 'matchit.zip'

" non github repos


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
set scrolloff=3
set shortmess=atI
set autoindent
syntax on
set hlsearch
set t_Co=256
set hidden
set tags+=tags;$HOME
"set list
set listchars=tab:▸\ ,eol:¬
set laststatus=2

let g:LustyJugglerShowKeys = 'a'
let g:snips_author = 'Brandon Waskiewicz'

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" Plugin bindings
nnoremap <silent> <F9> :TagbarToggle<CR>
nnoremap <F5> :GundoToggle<CR>
nn <silent> <Leader>t :CommandT<CR>
nn <silent> <Leader>s :nohls<CR>
nn <silent> <Leader>n :NERDTreeToggle<CR>
nn <silent> <Leader>a :A<CR>
nn <silent> <Leader>ig :IndentGuidesToggle<CR>
nn <silent> <Leader>c :SyntasticToggleMode<CR>
nmap <SPACE> :
imap ii <Esc>

" Window switching bindings
nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l

" Open file bindings
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>

cmap w!! %!sudo tee > /dev/null %

let $PAGER=''
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL%'
let c_syntax_for_h = 1
let g:xml_syntax_folding = 1
let g:Powerline_symbols = 'unicode'
let g:syntastic_auto_loc_list = 1
let g:syntastic_c_check_header = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_mode_map = { 'mode': 'passive',
			   \ 'active_filetypes': ['c', 'haskell'],
			   \ 'passive_filetypes': [] }


set background=dark
colorscheme solarized

" Removes trailing spaces
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

  autocmd FileType xml setlocal foldmethod=syntax
  autocmd FileType text setlocal textwidth=79
  autocmd FileType c setlocal textwidth=80
  autocmd FileType c setlocal fo+=t
  autocmd FileType gitcommit hi def link gitcommitOverflow Error
  autocmd FileWritePre    * :call TrimWhiteSpace()
  autocmd FileAppendPre   * :call TrimWhiteSpace()
  autocmd FilterWritePre  * :call TrimWhiteSpace()
  autocmd BufWritePre     * :call TrimWhiteSpace()
else

endif " has("autocmd")
