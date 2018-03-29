set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
set rtp+=~/.fzf
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'neomake/neomake'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-unimpaired'
Plugin 'rust-lang/rust.vim'
Plugin 'a.vim'
Plugin 'cscope_macros.vim'
Plugin 'closetag.vim'
Plugin 'chase/vim-ansible-yaml'
Plugin 'mbbill/undotree'
Plugin 'wlangstroth/vim-racket'
Plugin 'paredit.vim'
Plugin 'jpalardy/vim-slime'
Plugin 'machakann/vim-highlightedyank'
Plugin 'pangloss/vim-javascript'
Plugin 'digitaltoad/vim-pug'
Plugin 'embear/vim-localvimrc'

Plugin 'gregsexton/gitv'

call vundle#end()

filetype plugin indent on

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
set scrolloff=5
set shortmess=atI
set autoindent
set clipboard+=unnamedplus
set t_Co=256
set hidden
set tags+=tags;$HOME
set laststatus=2
set wildmenu
set wildignorecase
set colorcolumn=+1
set completeopt=menuone,longest,preview
set number
set relativenumber
set background=dark
set tabline=%!MyTabLine()
set diffopt=vertical
set dir=~/.swap
set path=.,**
set mouse=a
set scrollback=100000

syntax on
colorscheme solarized

let mapleader="\\"
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:undotree_SplitWidth = 40
let g:airline_exclude_preview = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#branch#enabled = 0
let g:solarized_diffmode = "high" " high, low, normal

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
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": ""}
let g:slime_dont_ask_default = 1
let g:neomake_list_height = 15
let g:neomake_error_sign = {
    \   'text': '✖',
    \   'texthl': 'ErrorMsg',
    \ }
let g:neomake_warning_sign = {
    \   'text': '⚠',
    \   'texthl': 'DiffChange',
    \ }
let g:neomake_message_sign = {
    \   'text': '➤',
    \   'texthl': 'StatusLine',
    \ }
let g:neomake_info_sign = {
    \   'text': 'ℹ',
    \   'texthl': 'helpExample',
    \ }
let g:javascript_plugin_jsdoc = 1
let g:localvimrc_sandbox = 0
let g:localvimrc_whitelist = ['/home/brandon/code/*/']

noremap <space> :
nnoremap gob :ls<CR>:b<Space>
nnoremap gof :FZF<CR>
nnoremap goe :Lex<CR>
nnoremap <silent> <F9> :TagbarOpenAutoClose<CR>
nnoremap <F5> :UndotreeToggle<cr>
nnoremap <silent> <Leader>a :A<CR>
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
nnoremap gsp :let cmd="silent grep! " . GetCurrentWord() . " --iglob !tests" <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nnoremap gcf :let @+ = expand("%")<CR>
map y <Plug>(highlightedyank)

cmap w!! %!sudo tee > /dev/null %

if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

if has("gui_running")
  set guifont=Dina
  set guioptions-=T
  set guioptions-=m
  set lines=60
endif

if has('nvim')
  set inccommand=nosplit
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

function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
    endif

    return s
endfunction

function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return bufname(buflist[winnr - 1])
endfunction

if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!
    autocmd QuickFixCmdPost *grep* cwindow
    autocmd FileType text                setlocal tw=80
    autocmd FileType html,xml,htmldjango setlocal et ai tw=0 ts=4 sw=4 fdm=syntax
    autocmd FileType mkd                 setlocal et ai tw=80 ts=4 sw=4 cc=+1
    autocmd FileType md,tex 	         setlocal et ai tw=80 ts=4 sw=4 cc=+1
    autocmd FileType css,sass,scss       setlocal et ai tw=80 ts=2 sw=2
    autocmd FileType javascript,json     setlocal et tw=100 ts=4 sw=4 ai sr fdm=indent foldlevel=99
    autocmd FileType python              setlocal et tw=100 ts=4 sw=4 ai sr fdm=indent foldlevel=99
    autocmd FileType sql 		 setlocal et tw=80 ts=4 sw=4 ai
    autocmd FileType groovy 		 setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99
    autocmd FileType ruby 		 setlocal et tw=80 ts=4 sw=4 ai sr fdm=indent foldlevel=99
    autocmd FileType rust 		 setlocal et tw=100 ts=4 sw=4
    autocmd FileType c 			 setlocal textwidth=80 formatoptions+=t
    autocmd FileType haskell 		 setlocal textwidth=80 ts=4 sw=4 et
    autocmd FileType gitcommit 		 setlocal spell
    autocmd FileType gitcommit hi def link gitcommitOverflow Error
    autocmd FileWritePre,FileAppendPre,BufWritePre  * :call TrimWhiteSpace()
    autocmd BufRead,BufNewFile Vagrantfile set ft=ruby
    autocmd BufWritePost * Neomake
    if v:version >= 700 && !&diff
        autocmd BufEnter,BufRead * if exists("b:view") | call winrestview(b:view) | endif
        autocmd BufLeave,BufReadPre * let b:view = winsaveview()
    endif
    if has('nvim')
        autocmd TermOpen * setlocal nonumber norelativenumber
    endif
  augroup END
else

endif " has("autocmd")
