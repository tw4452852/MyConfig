define-command ww -docstring "sudo write" %{
    execute-keys %{<percent><a-|>sudo tee } "%val{buffile}" > /dev/null<ret>
}
