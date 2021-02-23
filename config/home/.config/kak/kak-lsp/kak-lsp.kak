eval %sh{kak-lsp --kakoune -s $kak_session}
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
hook global WinSetOption filetype=(go|c|cpp|dart|rust) %{
        lsp-enable-window
}

def lsp-snippets-insert -override -hidden -params 1 %[
    eval %sh{
        if ! command -v perl > /dev/null 2>&1; then
            printf "fail '''perl'' must be installed to use the ''snippets-insert'' command'"
        fi
    }
    eval -draft -save-regs '^"' %[
        reg '"' %arg{1}
        exec <a-P>
        # replace leading tabs with the appropriate indent
        try %{
            reg '"' %sh{
                if [ $kak_opt_indentwidth -eq 0 ]; then
                    printf '\t'
                else
                    printf "%${kak_opt_indentwidth}s"
                fi
            }
            exec -draft '<a-s>s\A\t+<ret>s.<ret>R'
        }
        # align everything with the current line
        eval -draft -itersel -save-regs '"' %{
            try %{
                exec -draft -save-regs '/' '<a-s>)<space><a-x>s^\s+<ret>y'
                exec -draft '<a-s>)<a-space>P'
            }
        }
        try %[
            # select things that look like placeholders
            # this regex is not as bad as it looks
            eval -draft %[
                exec s((?<lt>!\\)(\\\\)*|\A)\K(\$(\d+|\{(\d+(:(\\\}|[^}])?)?)\}))<ret>
                # tests
                # $1                - ok
                # ${2}              - ok
                # $1$2$3            - ok x3
                # $1${2}$3${4}      - ok x4
                # $1\${2}\$3${4}    - ok, not ok, not ok, ok
                # \\${3:abc}        - ok
                # \${3:abc}         - not ok
                # \\\${3:abc}def    - not ok
                # ${4:a\}b}def      - ok
                # ${5:ab\}}def      - ok
                # ${6:ab\}cd}def    - ok
                # ${7:ab\}\}cd}def  - ok
                # ${8:a\}b\}c\}}def - ok
                lsp-snippets-insert-perl-impl
            ]
        ]
        try %{
            # unescape $
            exec 's\\\$<ret>;d'
        }
    ]
]

map global user l ': enter-user-mode lsp<ret>' -docstring 'lsp mode'
