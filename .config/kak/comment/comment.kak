declare-user-mode comment

map global comment l ':comment-line<ret>'           -docstring 'line comment'
map global comment b ':comment-block<ret>'          -docstring 'block comment'

map global user c ': enter-user-mode comment<ret>'  -docstring 'comment mode'
