declare-option -hidden str previous_client

define-command -hidden _switch -params ..1 %{
  evaluate-commands %sh{
    cur=${kak_client}
    if [ $# -eq 1 ]; then
      printf "evaluate-commands -client '%s' focus\n" "$1"
    else
      printf "evaluate-commands -client '%s' focus\n" "${kak_opt_previous_client}"
    fi
    printf "evaluate-commands set-option global previous_client '%s'" "$cur"
  }
}

declare-user-mode switch

map global switch m ': _switch main<ret>'            -docstring 'switch to main client'
map global switch t ': _switch tools<ret>'           -docstring 'switch to tools client'
map global switch d ': _switch docs<ret>'            -docstring 'switch to docs client'
map global switch s ': _switch<ret>'                 -docstring 'switch to previous client'

map global user s ': enter-user-mode switch<ret>' -docstring 'switch mode'
