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
let Tlist_Show_One_File = 1
let Tlist_Close_On_Select = 1
let TList_Process_File_Always = 1
let $PAGER=''
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL%'
let c_syntax_for_h = 1
let g:xml_syntax_folding = 1

set background=dark
colorscheme solarized
" inkpot molokai solarized

if has("gui_running")
  set guifont=Dina
  set guioptions-=T
  set guioptions-=m
  set lines=60
endif

if has("autocmd")
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  autocmd FileType xml setlocal foldmethod=syntax
  autocmd FileType text setlocal textwidth=79
  autocmd FileType c setlocal textwidth=80
  autocmd FileType c setlocal fo+=t
  autocmd FileType gitcommit hi def link gitcommitOverflow Error
  "autocmd FileType clojure set path+=/home/brandon/code/**1/src
else

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" Returns a space if there are synastic errors, and no space if there aren't
function! BW_syntasticStatuslineSpace()
    if len(SyntasticStatuslineFlag()) > 0
	return ' '
    else
        return ''
    endif
endfunction


" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
