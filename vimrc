set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
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
Plugin 'scrooloose/syntastic'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-unimpaired'
Plugin 'rust-lang/rust.vim'
Plugin 'a.vim'
Plugin 'cscope_macros.vim'
Plugin 'closetag.vim'
Plugin 'ledger/vim-ledger'
Plugin 'chase/vim-ansible-yaml'

Plugin 'gregsexton/gitv'
Plugin 'tpope/vim-dispatch'
Plugin 'mbbill/undotree'
" Plugin 'szw/vim-ctrlspace'
Plugin 'ctrlpvim/ctrlp.vim'

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
set t_Co=256
set hidden
set tags+=tags;$HOME
set laststatus=2
set wildmenu
set wildignorecase
set colorcolumn=+1
set completeopt=menuone,longest,preview
set rnu
set nu
set background=dark
set tabline=%!MyTabLine()
set diffopt=vertical
set dir=~/.swap
set path=.,**

let g:ctrlp_max_files = 0
let g:ctrlp_lazy_update = 1
let g:ctrlp_default_input = 1
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:100'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_user_command = ['.git/', 'git ls-files --cached --others  --exclude-standard %s']
let g:ledger_fillstring = '>>'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:undotree_SplitWidth = 40
let g:airline_exclude_preview = 1
let g:airline#extensions#tabline#enabled = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSetDefaultMapping = 0
let g:solarized_diffmode = "high"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active' }
let g:syntastic_python_checkers = ["flake8"]
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

nn gob :ls<CR>:b<Space>
nn gof :find *
nn got :tabfind *
nn gos :sfind *
nn gov :vert sfind *
" nn <silent> gob :CtrlPBuffer<CR>
" nn <silent> gof :CtrlP<CR>
" nn <silent> gob :CtrlSpace h<CR>
" nn <silent> gof :CtrlSpace O<CR>
" nn <silent> got :CtrlSpace l<CR>
" nn <silent> gow :CtrlSpace w<CR>
nn goe :Lex<CR>
nn <silent> gst :SyntasticToggle<CR>
nn <silent> <F9> :TagbarOpenAutoClose<CR>
nn <F5> :UndotreeToggle<cr>
nn <silent> <Leader>a :A<CR>
nn gwn <C-W><C-W>
vn gwn <C-W><C-W>
nn gwp <C-W>W
vn gwp <C-W>W
nn gwh <C-W>h
vn gwh <C-W>h
nn gwj <C-W>j
vn gwj <C-W>j
nn gwk <C-W>k
vn gwk <C-W>k
nn gwl <C-W>l
vn gwl <C-W>l
nn gew :e <C-R>=expand("%:p:h") . "/" <CR>
nn gsa :let cmd="grep! " . GetCurrentWord() <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nn gsp :let cmd="grep! " . GetCurrentWord() . " --ignore tests --ignore migrations --ignore core_data.json --ignore schema.sql" <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nn gcf :let @+ = expand("%")<CR>

cmap w!! %!sudo tee > /dev/null %

if executable('ag')
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

if has("gui_running")
  set guifont=Dina
  set guioptions-=T
  set guioptions-=m
  set lines=60
endif

function! GetCurrentWord()
  return shellescape(expand("<cWORD>"))
endfunction

function! TrimWhiteSpace()
    %s/\s\+$//e
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

  au QuickFixCmdPost *grep* cwindow
  au FileType text setlocal tw=79
  au FileType html,xml,htmldjango setlocal et ai tw=0 ts=4 sw=4 fdm=syntax
  au FileType mkd setlocal et ai tw=79 ts=4 sw=4 cc=+1
  au FileType css,sass,scss setlocal et ai tw=79 ts=2 sw=2
  au FileType python setlocal et tw=79 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  au FileType javascript setlocal et tw=79 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  au FileType ruby setlocal et tw=79 ts=4 sw=4 ai sr fdm=indent foldlevel=99
  au FileType rust setlocal et tw=100 ts=4 sw=4
  au FileType gitcommit hi def link gitcommitOverflow Error
  au FileType gitcommit setlocal spell
  au FileWritePre,FileAppendPre,BufWritePre  * :call TrimWhiteSpace()
  au FileType c setlocal textwidth=80 formatoptions+=t
  au FileType haskell setlocal textwidth=80 ts=4 sw=4 et
  au BufNewFile,BufRead *.ldg,*.ledger setf ledger
  au FileType ledger setlocal ts=2 sw=2
  au BufRead,BufNewFile Vagrantfile set ft=ruby
else

endif " has("autocmd")
