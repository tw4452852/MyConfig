if exists("g:loaded_youdao")
  finish
endif
let g:loaded_youdao = 1

if has('nvim')
  function! s:WorkHandler(job_id, data, event)
    if a:event == 'stdout'
      echo '[youdao] ' .join(a:data, "\n")
    elseif a:event == 'stderr'
      echo '[youdao] error: ' .join(a:data)
    else
      echo '[youdao] exit: ' .a:data
    endif
  endfunction
  let s:callbacks = {
        \ 'on_stdout': function('s:WorkHandler'),
        \ 'on_stderr': function('s:WorkHandler'),
        \ 'on_exit': function('s:WorkHandler')
        \ }
  let s:work_job = jobstart(['zsh'], s:callbacks)
endif

function! s:yd(...)
  let c = substitute(join(a:000, " "), '\n\|\r', " ", "")
  let c = substitute(c, '\(^\s\+\)\|\(\s\+$\)', "", "g")
  let c = shellescape(c)
  if has('nvim')
    call jobsend(s:work_job, "youdao-translation " . c . "\n")
  else
    echo system("youdao-translation " . c))
  endif
endfunction

function! s:opfunc(type)
  let reg_save = @@

  if a:type ==? "v" || a:type ==# ""
    silent normal! `<v`>y
  else
    silent normal! `[v`]y
  endif
  call s:yd(@@)

  let @@ = reg_save
endfunction

xnoremap <silent> <Plug>YoudaoTranslate :<c-u>call <SID>opfunc(visualmode())<cr>
nnoremap <silent> <Plug>YoudaoTranslate :<c-u>set opfunc=<SID>opfunc<cr>g@
command! -nargs=+ YoudaoTranslate :call s:yd(<f-args>)

if !hasmapto('<Plug>YoudaoTranslate')
  xmap <leader>yd <Plug>YoudaoTranslate
  nmap <leader>yd <Plug>YoudaoTranslate
endif

" vim:set et sw=2:
