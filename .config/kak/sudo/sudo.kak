define-command ww -docstring "sudo write" %{
    execute-keys -draft %{ %<a-|>sudo tee } "%val{buffile}" > /dev/null<ret>
}
