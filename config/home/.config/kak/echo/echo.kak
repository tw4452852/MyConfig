declare-user-mode echo

map global echo o ':echo %opt{}<left>'          -docstring 'opt'
map global echo r ':echo %reg{}<left>'          -docstring 'reg'
map global echo s ':echo %sh{}<left>'           -docstring 'sh'
map global echo v ':echo %val{}<left>'          -docstring 'val'

map global user e ': enter-user-mode echo<ret>' -docstring 'echo mode'
