set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdcommenter'
Plugin 'bling/vim-airline'
Plugin 'mbbill/undotree'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-repeat'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'gregsexton/gitv'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'bitc/lushtags'
Plugin 'scrooloose/syntastic'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'kien/ctrlp.vim'
Plugin 'wting/rust.vim'
Plugin 'a.vim'
Plugin 'cscope_macros.vim'
Plugin 'ledger/vim-ledger'
Plugin 'chase/vim-ansible-yaml'
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
set colorcolumn=+1
set completeopt=menuone,longest,preview
set rnu
set nu
set background=dark
set tabline=%!MyTabLine()

let g:ctrlp_working_path_mode = '0'
let g:ledger_fillstring = '>>'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:undotree_SplitWidth = 40
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_always_populate_location_list = 1
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
let g:solarized_diffmode = "high"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['c', 'python', 'htmldjango'],
                           \ 'passive_filetypes': [] }
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

nm <SPACE> :
nn <silent> gof :CtrlP<CR>
nn <silent> gob :CtrlPBuffer<CR>
nn <silent> gom :CtrlPMRU<CR>
nn <silent> <F9> :TagbarOpenAutoClose<CR>
nn <silent> <F5> :UndotreeToggle<CR>
nn <silent> <Leader>a :A<CR>
nn <Leader>t= :Tabularize /[^=]\+\zs=\(=\)\@!<CR>
vn <Leader>t= :Tabularize /[^=]\+\zs=\(=\)\@!<CR>
ino <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
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
