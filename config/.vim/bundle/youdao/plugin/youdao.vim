function! s:YoudaoTranslate(...)
	let result=system("youdao-translation" . ' ' . join(a:000, " "))
	echo result
endfunction

command! -nargs=* YoudaoTranslate :call <SID>YoudaoTranslate(<f-args>)
