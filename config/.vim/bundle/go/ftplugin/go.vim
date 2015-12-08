" Copyright 2013 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
" go.vim: Vim filetype plugin for Go.

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

let b:undo_ftplugin = "setl com< cms<"

function! s:NextSection(backwards, visual)
	if a:visual
		normal! gv
	endif

	if a:backwards
		let pattern = '\v(^func \S*.*\{$|%^)'
	else
		let pattern = '\v(^func \S*.*\{$|%$)'
	endif
	let flags = 'e'

	if a:backwards
		let dir = '?'
	else
		let dir = '/'
	endif

	echom "backwards ". a:backwards . "visual " . a:visual
	execute 'silent normal! ' . dir . pattern . dir . flags . "\r"
endfunction

nnoremap <script> <buffer> <silent> ]]
        \ :call <SID>NextSection(0, 0)<cr>

nnoremap <script> <buffer> <silent> [[
        \ :call <SID>NextSection(1, 0)<cr>

vnoremap <script> <buffer> <silent> ]]
        \ :<c-u>call <SID>NextSection(0, 1)<cr>

vnoremap <script> <buffer> <silent> [[
        \ :<c-u>call <SID>NextSection(1, 1)<cr>

" vim:ts=4:sw=4:et
