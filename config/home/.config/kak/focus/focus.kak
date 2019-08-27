declare-user-mode focus

map global focus m ':focus main<ret>'            -docstring 'switch to main client'
map global focus t ':focus tools<ret>'           -docstring 'switch to tools client'
map global focus d ':focus docs<ret>'            -docstring 'switch to docs client'

map global user f ': enter-user-mode focus<ret>' -docstring 'focus mode'
