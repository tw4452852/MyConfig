" use go test -c for test files
if expand('%:t:r') =~# '.*_test$'
	CompilerSet makeprg=go\ test\ -c
endif
