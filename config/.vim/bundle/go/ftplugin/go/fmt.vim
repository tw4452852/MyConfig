" Copyright 2011 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
" fmt.vim: Vim command to format Go files with gofmt.
"
" This filetype plugin add a new commands for go buffers:
"
"   :Fmt
"
"       Filter the current Go buffer through gofmt.
"       It tries to preserve cursor position and avoids
"       replacing the buffer with stderr output.
"
" Options:
"
"   g:go_fmt_commands [default=1]
"
"       Flag to indicate whether to enable the commands listed above.
"
if exists("b:did_ftplugin_go_fmt")
    finish
endif


if !exists("g:go_fmt_commands")
    let g:go_fmt_commands = 1
endif


if g:go_fmt_commands
    command! -buffer Fmt call s:GoFormat()
endif

" update_file updates the target file with the given formatted source
function! s:update_file(source, target)
  " remove undo point caused via BufWritePre
  try | silent undojoin | catch | endtry

  let old_fileformat = &fileformat

  call rename(a:source, a:target)

  " reload buffer to reflect latest changes
  silent! edit!

  let &fileformat = old_fileformat
  let &syntax = &syntax

endfunction

" parse_errors parses the given errors and returns a list of parsed errors
function! s:parse_errors(filename, content) abort
  let splitted = split(a:content, '\n')

  " list of errors to be put into location list
  let errors = []
  for line in splitted
    let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
    if !empty(tokens)
      call add(errors,{
            \"filename": a:filename,
            \"lnum":     tokens[2],
            \"col":      tokens[3],
            \"text":     tokens[4],
            \ })
    endif
  endfor

  return errors
endfunction

function! s:GoFormat()
    let view = winsaveview()
    let l:tmpname = tempname()
    call writefile(getline(1, '$'), l:tmpname)
    let out = system("gofmt -s -w " . l:tmpname)
    if v:shell_error
        let errors = s:parse_errors(expand('%'), out)
        if !empty(errors)
            call setloclist(0, errors, 'r')
            lopen
        endif
        echohl Error | echomsg "Gofmt returned error" | echohl None
    else
        lclose
        call s:update_file(l:tmpname, expand('%'))
    endif
    call delete(l:tmpname)
    call winrestview(view)
endfunction

let b:did_ftplugin_go_fmt = 1

" vim:ts=4:sw=4:et
