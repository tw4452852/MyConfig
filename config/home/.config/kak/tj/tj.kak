define-command -hidden tj %{
    prompt "jump to line: " %{
        execute-keys -client %opt{toolsclient} -with-hooks "%val{text}g<ret>"
    }
}

map global user j ': tj<ret>' -docstring 'jump to specified line in toolsclient'
