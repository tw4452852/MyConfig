define-command ww -docstring "sudo write" %{
    execute-keys -draft %{<percent><a-|>sudo tee } "%val{buffile}" > /dev/null<ret>
}
