function! s:youdaoTranslate(...)
	let result=system("youdao-translation" . ' ' . join(a:000, " "))
	echo result
endfunction

command! -buffer -nargs=* YoudaoTranslate :call s:youdaoTranslate(<f-args>)
