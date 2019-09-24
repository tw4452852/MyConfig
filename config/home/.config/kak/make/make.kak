declare-user-mode make

map global make ] ': make-next-error<ret>'              -docstring 'next error'
map global make [ ': make-previous-error<ret>'          -docstring 'previous error'

map global user m ': enter-user-mode make<ret>'         -docstring 'makefile mode'
