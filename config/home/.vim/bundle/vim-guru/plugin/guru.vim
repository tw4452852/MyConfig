function! s:offset(line, col)
  if &encoding != 'utf-8'
    let sep = "\n"
    let buf = a:line == 1 ? '' : (join(getline(1, a:line-1), sep) . sep)
    let buf .= a:col == 1 ? '' : getline('.')[:a:col-2]
    return len(iconv(buf, &encoding, 'utf-8'))
  endif
  return line2byte(a:line) + (a:col-2)
endfunction

function! Guru(mode)
  let command = "guru -scope ."

  let old_efm = &errorformat
  " match two possible styles of errorformats:
  "
  "   'file:line.col-line2.col2: message'
  "   'file:line:col: message'
  "
  " We discard line2 and col2 for the first errorformat, because it's not
  " useful and location only has the ability to show one line and column
  " number
  let &errorformat = "%f:%l.%c-%[%^:]%#:\ %m,%f:%l:%c:\ %m"

  let filename = fnamemodify(expand("%"), ':p:gs?\\?/?')
  let in = ""
  if &modified
    let content  = join(getline(1, '$'), "\n")
    let in = filename . "\n" . strlen(content) . "\n" . content
    let command .= " -modified"
  endif

  let offset = s:offset(line('.'), col('.'))
  let filename .= printf(":#%s", offset)
  let command .= printf(" %s %s", a:mode, shellescape(filename))

  if &modified
      let out = system(command, in)
    else
      let out = system(command)
  endif

  if out =~ 'guru: '
    let out=substitute(out, '\n$', '', '')
    echom out
  else
    cgetexpr out
    copen
    let g:quickfix_is_open = 1
  endif

  let &errorformat = old_efm
endfunction

" vim: sw=2 ts=2 et
