eval %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(go|c|cpp) %{
        lsp-enable-window
}

map global user l ': enter-user-mode lsp<ret>' -docstring 'lsp mode'
