eval %sh{kak-lsp --kakoune -s $kak_session}
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
hook global WinSetOption filetype=(go|c|cpp|dart|rust) %{
        lsp-enable-window
}

define-command -hidden insert-tab %{
 try %{
   lsp-snippets-select-next-placeholders
   exec '<a-;>d'
 } catch %{
   exec -with-hooks '<tab>'
 }
}
map global insert <tab> "<a-;>: insert-tab<ret>"

map global user l ': enter-user-mode lsp<ret>' -docstring 'lsp mode'
