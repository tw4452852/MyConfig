hook global WinSetOption filetype=dart %{
    # Indent with 2 space
    set-option global indentwidth 2
}

# Auto formatting before writing
hook global BufWritePre .*\.dart %{ lsp-formatting }
