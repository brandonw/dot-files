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
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'
Bundle 'gregsexton/gitv'

Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-markdown'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'sjl/gundo.vim'
Bundle 'godlygeek/tabular'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-repeat'
Bundle 'bitc/lushtags'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdcommenter'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/syntastic'
Bundle 'Lokaltog/vim-powerline'
Bundle 'Shougo/neocomplcache'
Bundle 'ujihisa/neco-ghc'
Bundle 'Shougo/vimproc'
Bundle 'eagletmt/ghcmod-vim'
Bundle 'mattn/webapi-vim'
Bundle 'saltstack/salt-vim'

" vim-scripts repos
Bundle 'a.vim'
Bundle 'cscope_macros.vim'
Bundle 'matchit.zip'
Bundle 'pydoc.vim'
Bundle 'Gist.vim'

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
set wildmenu
set colorcolumn=+1
set completeopt=menuone,longest,preview
set nu

" Plugin bindings
nn <silent> <F9> :TagbarToggle<CR>
nn <silent> <F5> :GundoToggle<CR>
nn <silent> <Leader>/ :nohls<CR>
nn <silent> <Leader>a :A<CR>
nn <silent> <Leader>c :SyntasticToggleMode<CR>
nn <silent> <F8> :call UltiSnips_ListSnippets()<CR>
nn <Leader>t= :Tabularize /[^=]\+\zs=\(=\)\@!<CR>
vn <Leader>t= :Tabularize /[^=]\+\zs=\(=\)\@!<CR>
im <F8> :call UltiSnips_ListSnippets()<CR>
nm <SPACE> :
im jk <Esc>
im <C-F> <ESC>:r!google-contacts-lookup.sh <cword><CR><ESC>
ino <expr><nul>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>"

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

" use Ctrl+L to toggle the line number counting method
function! g:ToggleNuMode()
  if &nu == 1
     set rnu
  else
     set nu
  endif
endfunction
nnoremap <silent><C-L> :call g:ToggleNuMode()<cr>

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
			   \ 'active_filetypes': ['c', 'python', 'haskell'],
			   \ 'passive_filetypes': [] }
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:tagbar_autoclose = 1
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_disable_auto_complete = 1
let g:ctrlp_open_new_file = 'r'

set background=dark
colorscheme solarized

"match ErrorMsg '\s\+$'

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
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType text setlocal textwidth=79
  autocmd FileType c setlocal textwidth=80 formatoptions+=t
  autocmd FileType python setlocal foldmethod=indent foldlevel=99
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
  autocmd FileType haskell setlocal textwidth=80 ts=4 sw=4 et
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  autocmd FileType gitcommit hi def link gitcommitOverflow Error
  autocmd FileType gitcommit setlocal spell
  autocmd BufRead /tmp/mutt-* set tw=72
  autocmd FileWritePre  * :call TrimWhiteSpace()
  autocmd FileAppendPre * :call TrimWhiteSpace()
  autocmd BufWritePre   * :call TrimWhiteSpace()
else

endif " has("autocmd")
