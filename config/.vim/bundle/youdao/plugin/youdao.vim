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
	function! s:YoudaoTranslate(...)
		call jobsend(s:work_job, "youdao-translation " . join(a:000, " ") . "\n")
	endfunction
else
	function! s:YoudaoTranslate(...)
		let result=system("youdao-translation" . ' ' . join(a:000, " "))
		echo result
	endfunction
endif

command! -nargs=* YoudaoTranslate :call <SID>YoudaoTranslate(<f-args>)
