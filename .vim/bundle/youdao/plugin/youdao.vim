function! s:youdaoTranslate(...)
	let result=system("youdao-translation" . ' ' . join(a:000, " "))
	echo result
endfunction

command! -nargs=* YoudaoTranslate :call s:youdaoTranslate(<f-args>)
