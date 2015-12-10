if exists("g:match_load")
  finish
endif
let g:match_load = 1

let s:matches = [
			\{'group': 'WildMenu', 'pattern': '', 'id': 4},
			\{'group': 'Cursor', 'pattern': '', 'id': 5},
			\{'group': 'DiffAdd', 'pattern': '', 'id': 6},
			\]

function! TwMatchClearall()
	for mt in s:matches
		if mt.pattern != ''
			let mt.pattern = ''
			call matchdelete(mt.id)
		endif
	endfor
endf

function! TwMatchToggle(word)
	" clear if any
	for mt in s:matches
		if mt.pattern ==# a:word
			let mt.pattern = ''
			call matchdelete(mt.id)
			return
		endif
	endfor

	" find a free match
	for mt in s:matches
		if mt.pattern ==# ''
			let mt.pattern = a:word
			call matchadd(mt.group, a:word, 0, mt.id)
			return
		endif
	endfor

	" substitute s:matches[0]
	let mt = s:matches[0]
	call matchdelete(mt.id)
	let mt.pattern = a:word
	call matchadd(mt.group, a:word, 0, mt.id)
endf
