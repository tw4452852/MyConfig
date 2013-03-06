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
set linebreak
set tabstop=4
set shiftwidth=4
set softtabstop=4
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
"On Windows it use gb* encoding,
"it doesn't recognize these chars
if !has('win32') && !has('win64')
	set list
	set listchars=tab:»\ ,eol:¬,trail:▲,nbsp:▲
endif
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set mouse=a
set fdm=marker
set textwidth=80

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"myself keymap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

nnore / /\v
vnore / /\v

inore <f1> <esc>
nnore <f1> <esc>
vnore <f1> <esc>

nnore ; :
inore jj <esc>
nnore <leader>mk :w<cr>:make<cr>
inore <leader>mk <esc>:w<cr>:make<cr>
nnore <leader>mi :w<cr>:make install<cr>
inore <leader>mi <esc>:w<cr>:make install<cr>
nnore <leader>ms :w<cr>:make strip<cr>
inore <leader>ms <esc>:w<cr>:make strip<cr>
nnore <leader>w :update<cr>
inore <leader>w <esc>:update<cr>
nnore <leader><space> :noh<cr>
nnore <tab> %
vnore <tab> %
nnore <leader>at Vat
nnore <leader>ev <c-w><c-v><c-l>:e $MYVIMRC<cr>
nnore <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnore <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnore <leader>( viw<esc>a)<esc>hbi(<esc>lel
nnore <leader>< viw<esc>a><esc>hbi<<esc>lel
nnore <leader>{ viw<esc>a}<esc>hbi{<esc>lel
nnore <leader>[ viw<esc>a]<esc>hbi;<esc>lel
nnore <leader>; mqA;<esc>`q

"Quickfix
nnore <f2> :call QickfixToggle()<cr>

let g:quickfix_is_open = 0
function! QickfixToggle()
	if g:quickfix_is_open
		cclose
		let g:quickfix_is_open = 0
	else
		copen
		let g:quickfix_is_open = 1
	endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"tag list
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags
set noautochdir
let Tlist_Sort_Type = "name"
let Tlist_Show_Menu = 0
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow = 1
nnor <leader>t :TlistToggle<cr>
inor <leader>t <esc>:TlistToggle<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnor <leader>n :NERDTreeToggle<cr>
inor <leader>n <esc>:NERDTreeToggle<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Doxygen
"Dox        DoxAuthor  DoxBlock   DoxLic     DoxUndoc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnor <leader>da :DoxAuthor<cr>
inor <leader>da <esc>:DoxAuthor<cr>
nnor <leader>dl :DoxLic<cr>
inor <leader>dl <esc>:DoxLic<cr>
nnor <leader>df :Dox<cr>
inor <leader>df <esc>:Dox<cr>
nnor <leader>db :DoxBlock<cr>
inor <leader>db <esc>:DoxBlock<cr>
let g:DoxygenToolkit_authorName = "wtan"
let g:DoxygenToolkit_briefTag_funcName = "yes"
let g:DoxygenToolkit_licenseTag = "Copyright (c) 2006-2013 Hillstone Networks, Inc. \<enter>\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "PROPRIETARY RIGHTS of Hillstone Networks are involved in the\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "subject matter of this material.  All manufacturing, reproduction,\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "use, and sales rights pertaining to this subject matter are governed\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "by the license agreement.  The recipient of this software implicitly\<enter>"
let g:DoxygenToolkit_licenseTag = g:DoxygenToolkit_licenseTag . "accepts the terms of the license.\<enter>"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cscope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
endif

nnor <leader>ss :cs find s <C-R>=expand("<cword>")<cr><cr>
nnor <leader>sg :cs find g <C-R>=expand("<cword>")<cr><cr>
nnor <leader>sc :cs find c <C-R>=expand("<cword>")<cr><cr>
nnor <leader>st :cs find t <C-R>=expand("<cword>")<cr><cr>
nnor <leader>se :cs find e <C-R>=expand("<cword>")<cr><cr>
nnor <leader>sf :cs find f <C-R>=expand("<cfile>")<cr><cr>
nnor <leader>si :cs find i ^<C-R>=expand("<cfile>")<cr><cr>
nnor <leader>sd :cs find d <C-R>=expand("<cword>")<cr><cr>
nnor <c-]> :cs find g <C-R>=expand("<cword>")<cr><cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup gogroup
	au!
	au BufWritePre *.go :silent Fmt
	au BufNewFile,BufRead *.go ino <leader>go <c-x><c-o>
	au FileType go set makeprg=go\ build
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup mdgroup
	au!
	au FileType mkd set spell
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"youdao-traslation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnor <leader>tr :YoudaoTranslate <C-R>=expand("<cword>")<cr><cr>
