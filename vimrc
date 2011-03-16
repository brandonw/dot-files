" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Avoid duplicate auto commands when writing .vimrc
autocmd!

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

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
"set foldcolumn=1
syntax on
set hlsearch
set t_Co=256
set hidden
set laststatus=2
set tags+=tags;$HOME

if &diff
  
else
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  set statusline+=%{BW_syntasticStatuslineSpace()}
  let g:syntastic_enable_signs=1
  let g:syntastic_auto_loc_list=1
endif

set statusline+=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

let g:LustyJugglerShowKeys = 'a'
"let g:LustyJugglerShowKeys = 1
let g:snips_author = 'Brandon Waskiewicz'

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" Plugin bindings
nn <silent> <Leader>t :Tlist<CR><C-w>h
nn <silent> <Leader>s :nohls<CR>
nn <silent> <Leader>n :NERDTreeToggle<CR>
nn <silent> <Leader>j :LustyJuggler<CR>
nn <silent> <Leader>a :A<CR>

" Window switching bindings
nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l

" Open file bindings
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

let Tlist_Inc_Winwidth = 0
let $PAGER=''
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL%'

colorscheme inkpot
" inkpot molokai

if has("gui_running")
  set guifont=Inconsolata\ Medium\ 12
  set guioptions-=T
  set guioptions-=m
  set lines=60
endif

if has("autocmd")
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=79
  autocmd FileType c setlocal fo+=t
  autocmd FileType c setlocal cino=(0
  autocmd FileType c setlocal textwidth=80
  "autocmd FileType clojure set path+=/home/brandon/code/**1/src
else

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

function! BW_syntasticStatuslineSpace()
    if len(SyntasticStatuslineFlag()) > 0
	return ' '
    else
        return ''
    endif
endfunction
