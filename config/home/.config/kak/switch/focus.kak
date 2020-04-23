declare-user-mode switch

map global switch m ':focus main<ret>'            -docstring 'switch to main client'
map global switch t ':focus tools<ret>'           -docstring 'switch to tools client'
map global switch d ':focus docs<ret>'            -docstring 'switch to docs client'

map global user s ': enter-user-mode switch<ret>' -docstring 'switch mode'
