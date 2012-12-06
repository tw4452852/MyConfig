""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"myself setting 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
colorscheme tw
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin on
filetype indent on
set nocompatible
set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
"set expandtab

set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline 
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set nu
syntax enable
"set undofile
set list
set listchars=tab:»\ ,eol:¬,trail:▲,nbsp:▲

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set mouse=a

set fdm=marker

"tags
"set tags+=/home/wtan/cur/GEO_REL2_TRANSFORMER_NETFLOW/src/tags
"set tags+=/home/wtan/cur/GEO_REL2_TRANSFORMER_NETFLOW/src/meterd/tags
"set tags+=/home/wtan/cur/GEO_REL2_TRANSFORMER_NETFLOW/src/tf-x86/healthd/tags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"myself keymap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

nnoremap / /\v
vnoremap / /\v

inoremap <f1> <esc>
nnoremap <f1> <esc>
vnoremap <f1> <esc>
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

nnoremap ; :
inoremap jj <esc>
nnoremap <leader>mk :w<cr>:make<cr>
inoremap <leader>mk <esc>:w<cr>:make<cr>
nnoremap <leader>mi :w<cr>:make install<cr>
inoremap <leader>mi <esc>:w<cr>:make install<cr>
nnoremap <leader>ms :w<cr>:make strip<cr>
inoremap <leader>ms <esc>:w<cr>:make strip<cr>
nnoremap <leader>w :update<cr>
inoremap <leader>w <esc>:update<cr>
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %
nnoremap <leader>at Vat
nnoremap <leader>ev <c-w><c-v><c-l>:e $MYVIMRC<cr>

inore <f7> <esc>:cn<cr>
nnore <f7> :cn<cr>
inore <f6> <esc>:cl<cr>
nnore <f6> :cl<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"match (),{},[] 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"inoremap ( ()<ESC>i
"inoremap ) <c-r>=ClosePair(')')<CR>
"inoremap { {}<ESC>i
"inoremap } <c-r>=ClosePair('}')<CR>
"inoremap [ []<ESC>i
"inoremap ] <c-r>=ClosePair(']')<CR>
"
"function ClosePair(char)
"if getline('.')[col('.') - 1] == a:char
"return "\<Right>"
"else
"return a:char
"endif
"endf
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"tag list
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags
set noautochdir
let Tlist_Sort_Type = "name"
let Tlist_Show_Menu = 0
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow = 1
nnoremap <leader>t :TlistToggle<cr>   
inoremap <leader>t <esc>:TlistToggle<cr>   
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"miniBufExpl
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:miniBufExplModSelTarget = 1
"let g:miniBufExplorerMoreThanOne = 2
"let g:miniBufExplModSelTarget = 0
"let g:miniBufExplUseSingleClick = 1
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplSplitBelow = 0
"let g:bufExplorerSortBy = "name"
"nnoremap <leader>b :TMiniBufExplorer<cr>
"inoremap <leader>b <esc>:TMiniBufExlorer<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"snipmate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ino <leader>m <c-r>=TriggerSnippet()<cr>
snor <leader>m <esc>i<right><c-r>=TriggerSnippet()<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>n :NERDTreeToggle<cr>   
inoremap <leader>n <esc>:NERDTreeToggle<cr>   
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Doxygen
"Dox        DoxAuthor  DoxBlock   DoxLic     DoxUndoc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnor <leader>da :DoxAuthor<cr>
ino <leader>da <esc>:DoxAuthor<cr>
nnor <leader>dl :DoxLic<cr>
ino <leader>dl <esc>:DoxLic<cr>
nnor <leader>df :Dox<cr>
ino <leader>df <esc>:Dox<cr>
nnor <leader>db :DoxBlock<cr>
ino <leader>db <esc>:DoxBlock<cr>
let g:DoxygenToolkit_authorName = "wtan"
let g:DoxygenToolkit_briefTag_funcName = "yes"
let g:DoxygenToolkit_licenseTag = "Copyright (c) 2006-2011 Hillstone Networks, Inc. \<enter>\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "PROPRIETARY RIGHTS of Hillstone Networks are involved in the\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "subject matter of this material.  All manufacturing, reproduction,\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "use, and sales rights pertaining to this subject matter are governed\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "by the license agreement.  The recipient of this software implicitly\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "accepts the terms of the license.\<enter>"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cscope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
endif

nmap <leader>ss :cs find s <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<cr><cr>
nmap <leader>st :cs find t <C-R>=expand("<cword>")<cr><cr>
nmap <leader>se :cs find e <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>si :cs find i ^<C-R>=expand("<cfile>")<cr><cr>
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<cr><cr>
nmap <c-]> :cs find g <C-R>=expand("<cword>")<cr><cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWritePre *.go :silent Fmt
autocmd BufNewFile,BufRead *.go ino <leader>g <c-x><c-o>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.md set textwidth=100
autocmd BufNewFile,BufRead *.md set spell
