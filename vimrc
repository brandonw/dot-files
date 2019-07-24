set nocompatible
filetype off
set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
Plug 'nisavid/vim-colors-solarized'
" Plug 'chrisbra/csv.vim'
Plug 'digitaltoad/vim-pug'
Plug 'gregsexton/gitv'
Plug 'honza/vim-snippets'
Plug 'jpalardy/vim-slime'
Plug 'justinmk/vim-dirvish'
Plug 'machakann/vim-highlightedyank'
Plug 'mbbill/undotree'
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
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/closetag.vim'
Plug 'vim-scripts/cscope_macros.vim'
Plug 'vim-scripts/paredit.vim'
Plug 'wlangstroth/vim-racket'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

filetype plugin indent on

" enable matchit.vim that is included with vim
runtime macros/matchit.vim

" Install the following extensions:
" CocInstall coc-tsserver
" CocInstall coc-snippets
" CocInstall coc-json
" CocInstall coc-eslint
" CocInstall coc-lists

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
set shortmess=atIc
set autoindent
set clipboard+=unnamedplus
set hidden
set laststatus=2
set wildmenu
set wildignorecase
set colorcolumn=+1
set completeopt=menuone,longest,preview
set number
set relativenumber
set background=dark
set diffopt=vertical
set dir=~/.swap
set path=.,**
set mouse=a
set scrollback=100000
set switchbuf+=newtab
set nohls
set cmdheight=2
set updatetime=300
set signcolumn=yes
" set termguicolors

syntax on
colorscheme solarized
hi! link SignColumn LineNr

let mapleader="\\"
let g:undotree_SplitWidth = 40
let g:solarized_diffmode = "high" " high, low, normal
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '↪'
let g:airline_symbols.paste = 'paste'
let g:airline_symbols.spell = 'spell'
let g:airline_symbols.notexists = ' ∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#whitespace#checks = ['indent', 'trailing', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#trailing_format = ' trailing:[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = ' mixed-indent:[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format = ' mix-indent-file:[%s]'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_exclude_preview = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'

" let g:airline_section_c = '%<%<%{airline#extensions#fugitiveline#bufname()}%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
" let g:airline_section_error = '%{airline#util#wrap(airline#extensions#neomake#get_warnings(),0)}%{airline#util#wrap(airline#extensions#whitespace#check(),0)}%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
" call airline#parts#define_function('coc-context', 'GetCocContext')

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": ""}
let g:slime_dont_ask_default = 1

noremap <space> :
nnoremap gob :ls<CR>:b<Space>
nnoremap gof :FZF<CR>
nnoremap goe :Dirvish<CR>
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
nnoremap gsp :let cmd="silent grep! " . GetCurrentWord() . " --iglob !tests --iglob !test" <bar> exec cmd <bar> call histadd("cmd", cmd)<CR>
nnoremap gcf :let @+ = expand("%")<CR>
nnoremap gfj :%!python -m json.tool<CR>
vnoremap gfj :!python -m json.tool<CR>
nnoremap <F8> :CocList snippets<CR>
nnoremap gsd :CocList --normal diagnostics<CR>
map y <Plug>(highlightedyank)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" cmap w!! %!sudo tee > /dev/null % " doesn't currently work in nvim

if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ $*
  set grepformat=%f:%l:%c:%m
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

function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!
    autocmd QuickFixCmdPost *grep* cwindow
    autocmd FileType text                setlocal tw=80
    autocmd FileType sh                  setlocal et ai tw=80 ts=4 sw=4
    autocmd FileType html,xml,htmldjango setlocal et ai tw=0 ts=4 sw=4 fdm=syntax
    autocmd FileType mkd                 setlocal et ai tw=80 ts=4 sw=4 cc=+1
    autocmd FileType md,tex 	         setlocal et ai tw=80 ts=4 sw=4 cc=+1
    autocmd FileType css,sass,scss       setlocal et ai tw=80 ts=2 sw=2
    autocmd FileType javascript          setlocal et tw=120 ts=4 sw=4 ai sr fdm=indent foldlevel=99
    autocmd FileType javascript,json     setlocal formatexpr=CocAction('formatSelected')
    autocmd FileType json,pug,xml        setlocal et tw=100 ts=2 sw=2 ai sr fdm=indent foldlevel=99
    autocmd FileType yaml                setlocal et tw=100 ts=2 sw=2 ai sr
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
    " autocmd CmdwinEnter * let b:deoplete_sources = ['buffer']
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
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
