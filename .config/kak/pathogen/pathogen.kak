define-command pathogen-infect -params .. -file-completion -docstring 'pathogen-infect [path]…: Load recursively Kakoune files under given paths' %{ evaluate-commands %sh{
  find -L $@ -type f -name '*.kak' \
    -exec printf 'source %s\n' '{}' ';'
}}
