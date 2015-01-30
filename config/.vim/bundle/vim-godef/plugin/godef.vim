" needs https://code.google.com/p/rog-go/source/browse/exp/cmd/godef/godef.go

if !exists("g:godef_command")
    let g:godef_command = "godef"
endif

if !exists("g:godef_split")
    let g:godef_split = 0
endif

let s:positons_stack = []

function! GodefUnderCursor()
    let pos = getpos(".")[1:2]
    if &encoding == 'utf-8'
        let offs = line2byte(pos[0]) + pos[1]
    else
        let c = pos[1]
        let buf = line('.') == 1 ? "" : (join(getline(1, pos[0] - 1), "\n") . "\n")
        let buf .= c == 1 ? "" : getline(pos[0])[:c-2]
        let offs = len(iconv(buf, &encoding, "utf-8"))
    endif
    call Godef("-o=" . offs)
endfunction

function! Godef(arg)
	let old_efm = &errorformat
	let &errorformat = "%f:%l:%c"

	let pos = getpos(".")[1:2]
	let now_position = bufname("%") . ":" . pos[0] . ":" . pos[1]

    if &modified
        " XXX not ideal, but I couldn't find a good way
        "     to create a temporary buffer for use with
        "     a filter
        let filename=tempname()
        echomsg filename
        execute ":write " . filename
    else
        let filename=bufname("%")
    endif

    let out=system(g:godef_command . " -f=" . shellescape(filename) . " " . shellescape(a:arg))

    if out =~ 'godef: '
        let out=substitute(out, '\n$', '', '')
        echom out
    else
        if g:godef_split == 1
            split
        elseif g:godef_split == 2
            tabnew
        endif

		call add(s:positons_stack, now_position)

		cgetexpr out
		let num = len(getqflist())
		if num > 1
			copen
			let g:quickfix_is_open = 1
		else
			cc 1
		endif
    end

	let &errorformat = old_efm
endfunction

function! GodefBack()
	let old_efm = &errorformat
	let &errorformat = "%f:%l:%c"

	let size = len(s:positons_stack)
	if size == 0
		echom "the stack is empty"
	else
		lexpr remove(s:positons_stack, size-1)
	endif

	let &errorformat = old_efm
endfunction

command! -range -nargs=1 Godef :call Godef(<q-args>)
