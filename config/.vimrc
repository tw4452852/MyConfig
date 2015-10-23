" Basic settings"{{{
set t_Co=256
colorscheme tw
if !has('win32') && !has('win64')
	set guifont=Source\ Code\ Pro\ 10
else
	set guifont=Source_Code_Pro:h10
endif
filetype off
execute pathogen#infect()
filetype plugin on
filetype indent on
syntax enable
set nocompatible
set modelines=0
set linebreak
set textwidth=80
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
set number
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set mouse=a
set relativenumber
" On Windows it use gb* encoding,
" it doesn't recognize these chars
if !has('win32') && !has('win64')
	set encoding=utf-8
	set list
	set listchars=tab:»\ ,eol:¬,trail:▲,nbsp:▲
endif
"}}}
" vimrc"{{{
augroup vimgroup
	au!
	au FileType vim setlocal foldmethod=marker
augroup END
"}}}
" Status Line setting"{{{
set statusline=%F\ -\ %m%r%h[%Y-%{&fileformat}]%=[%B,%c][%l/%L]
"}}}
" Global keymaps"{{{
" General"{{{
let mapleader = ","
nnoremap <tab> %
vnoremap <tab> %
nnoremap / /\v
vnoremap / /\v
inoremap <f1> <esc>
nnoremap <f1> <esc>
vnoremap <f1> <esc>
nnoremap ; :
inoremap jj <esc>
nnoremap <A-j> <c-w>j
nnoremap <A-k> <c-w>k
nnoremap <A-l> <c-w>l
nnoremap <A-h> <c-w>h
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif
nnoremap <leader>mk :w<cr>:make<cr>
inoremap <leader>mk <esc>:w<cr>:make<cr>
nnoremap <leader>mi :w<cr>:make install<cr>
inoremap <leader>mi <esc>:w<cr>:make install<cr>
nnoremap <leader>ms :w<cr>:make strip<cr>
inoremap <leader>ms <esc>:w<cr>:make strip<cr>
nnoremap <leader>w :update<cr>
inoremap <leader>w <esc>:update<cr>
nnoremap <leader><space> :noh<cr>:call TwMatchClearall()<cr>
nnoremap <leader>at Vat
nnoremap <leader>ev <c-w><c-v><c-l>:e $MYVIMRC<cr>
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>< viw<esc>a><esc>hbi<<esc>lel
nnoremap <leader>{ viw<esc>a}<esc>hbi{<esc>lel
nnoremap <leader>[ viw<esc>a]<esc>hbi;<esc>lel
nnoremap <leader>; mqA;<esc>`q
" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
"Quickfix
nnoremap <leader>qf :call QickfixToggle()<cr>
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
"}}}
"tw's self cmd"{{{
nnoremap <leader>f :call <SID>TwFormat()<cr>
function! s:TwFormat()
	let linenum = 1
	for line in getline(1, line('$'))
		let repl = substitute(line, "；", ";", "g")
		let repl = substitute(repl, "。", ".", "g")
		let repl = substitute(repl, "，", ",", "g")
		let repl = substitute(repl, "：", ":", "g")
		let repl = substitute(repl, "（", "(", "g")
		let repl = substitute(repl, "）", ")", "g")
		let repl = substitute(repl, "“", "\"", "g")
		let repl = substitute(repl, "”", "\"", "g")
		call setline(linenum, repl)
		let linenum += 1
	endfor
endfunction

nnoremap <leader>gb :execute "!tw_blame -l " . line(".") . " -p " . expand("%:p")<cr>
cnoremap w!! w !sudo tee % >/dev/null
"}}}
"}}}
" Plugin-specific settings
" FZF"{{{
nnoremap <leader>zf :FZF<cr>
" List of buffers
function! BufList()
	redir => ls
	silent ls
	redir END
	return split(ls, '\n')
endfunction

function! BufOpen(e)
	execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>zb :call fzf#run({
		  \   'source':      reverse(BufList()),
		  \   'sink':        function('BufOpen'),
		  \   'options':     '+m',
		  \   'tmux_height': '40%'
		  \ })<CR>
"}}}
" Taglist"{{{
set tags+=tags
set noautochdir
let Tlist_Sort_Type = "name"
let Tlist_Show_Menu = 0
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow = 1
nnoremap <leader>t :TlistToggle<cr>
inoremap <leader>t <esc>:TlistToggle<cr>"}}}
" Cscope"{{{
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
endif
nnoremap <leader>ss :cs find s <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>sg :cs find g <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>sc :cs find c <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>st :cs find t <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>se :cs find e <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>sf :cs find f <c-r>=expand("<cfile>")<cr><cr>
nnoremap <leader>si :cs find i ^<c-r>=expand("<cfile>")<cr><cr>
nnoremap <leader>sd :cs find d <c-r>=expand("<cword>")<cr><cr>
"}}}
" Go"{{{
augroup gogroup
	au!
	au BufWritePre *.go :silent Fmt "gofmt
	au FileType go compiler go
	au FileType go nnoremap <buffer> <c-]> :call GodefUnderCursor()<cr>
	au FileType go nnoremap <buffer> <c-t> :call GodefBack()<cr>
	au FileType go nnoremap <buffer> K :Godoc<cr>
augroup END
"}}}
" Markdown"{{{
augroup mdgroup
	au!
	au FileType mkd setlocal spell
augroup END
"}}}
" Youdao-traslation"{{{
nnoremap <leader>tr :YoudaoTranslate <c-r>=expand("<cword>")<cr><cr>
"}}}
" Wmgraphviz"{{{
augroup dotgroup
	au!
	au FileType dot nnoremap <buffer> <leader>ll :GraphvizCompile<cr>
	au FileType dot nnoremap <buffer> <leader>lt :GraphvizCompileToLaTeX<cr>
	au FileType dot nnoremap <buffer> <leader>lv :GraphvizShow<cr>
	au FileType dot nnoremap <buffer> <leader>li :GraphvizInteractive<cr>
augroup END
"}}}
" Snipmate"{{{
" fix snippet_dir bug in windows
if has('win32') || has('win64')
	let g:snippets_dir='$HOME/vimfiles/bundle/snipmate/snippets'
endif
"}}}
" Help"{{{
augroup helpgroup
	au!
	autocmd FileType help wincmd L
augroup END
"}}}
" gtags"{{{
if filereadable("GTAGS")
	set cscopeprg=gtags-cscope
	cs add GTAGS
endif
"}}}
" match"{{{
nnoremap ? :call TwMatchToggle(expand("<cword>"))<cr>
"}}}
"terminal"{{{
if exists(':terminal')
	let g:terminal_scrollback_buffer_size = 100000
endif
"}}}
