declare-option -docstring "shell command run to perform a gtag search" \
    str gtagcmd 'global -xqa'
declare-option -docstring "shell command run to update gtag db" \
    str gtag_update_cmd 'global -u'
declare-option -docstring "name of the client in which utilities display information" \
    str toolsclient
declare-option -hidden int gtag_current_line 0

define-command -hidden -params 1.. gtag-impl %{ evaluate-commands %sh{
    cd "$(dirname "${kak_buffile}")"
    output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-gtag.XXXXXXXX)/fifo
    mkfifo ${output}
    ( ${kak_opt_gtagcmd} "$@" | tr -d '\r' > ${output} 2>&1 ) > /dev/null 2>&1 < /dev/null &
    printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
               edit! -fifo ${output} -scroll *gtag*
               set-option buffer filetype gtag
               set-option buffer gtag_current_line 0
               hook -always -once buffer BufCloseFifo .* %{ evaluate-commands %sh{
                   rm -r $(dirname ${output})
                   if [ \${kak_buf_line_count} -gt 2 ]; then
                   		echo nop
                   else
                   		echo gtag-next-match
                   fi
               }}
           }"
}}

define-command -params 1 \
-docstring 'gtag-path <pattern>: find file path according to the given pattern' gtag-path %{
	gtag-impl '-Po' %arg{@}
}

define-command -params 1 \
-docstring 'gtag-def <pattern>: find definition according to the given pattern' gtag-def %{
	gtag-impl '-d' %arg{@}
}

define-command -params 1 \
-docstring 'gtag-ref <pattern>: find reference according to the given pattern' gtag-ref %{
	gtag-impl '-rs' %arg{@}
}

define-command -params 1 \
-docstring 'gtag-grep <pattern>: find lines according to the given pattern' gtag-grep %{
	gtag-impl '-go' %arg{@}
}

hook -group gtag-highlight global WinSetOption filetype=gtag %{
    add-highlighter window/gtag group
    add-highlighter window/gtag/ regex "^\S+\s+(\d+) (\S+)" 1:green 2:cyan
    add-highlighter window/gtag/ line %{%opt{gtag_current_line}} default+b
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/gtag }
}

hook global WinSetOption filetype=gtag %{
    hook buffer -group gtag-hooks NormalKey <ret> gtag-jump
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks buffer gtag-hooks }
}

hook global BufWritePost .* %{
    evaluate-commands %{ try %sh{
        (cd "$(dirname "${kak_buffile}")" && ${kak_opt_gtag_update_cmd}) > /dev/null 2>&1 < /dev/null &
    }}
}

declare-option -docstring "name of the client in which all source code jumps will be executed" \
    str jumpclient

define-command -hidden gtag-jump %{
    evaluate-commands %{ # use evaluate-commands to ensure jumps are collapsed
        try %{
            execute-keys '<a-x>s^\S+\s+(\d+) (\S+)<ret>'
            set-option buffer gtag_current_line %val{cursor_line}
            evaluate-commands -try-client %opt{jumpclient} edit -existing %reg{2} %reg{1}
            try %{ focus %opt{jumpclient} }
        }
    }
}

define-command gtag-next-match -docstring 'Jump to the next gtag match' %{
    evaluate-commands -try-client %opt{toolsclient} %{
        buffer '*gtag*'
        # First jump to enf of buffer so that if gtag_current_line == 0
        # 0g<a-l> will be a no-op and we'll jump to the first result.
        # Yeah, thats ugly...
        execute-keys "ge %opt{gtag_current_line}g<a-l> /^\S+\s+\d+ \S+<ret>"
        gtag-jump
    }
    try %{ evaluate-commands -client %opt{toolsclient} %{ execute-keys gg %opt{gtag_current_line}g } }
}

define-command gtag-previous-match -docstring 'Jump to the previous gtag match' %{
    evaluate-commands -try-client %opt{toolsclient} %{
        buffer '*gtag*'
        # See comment in gtag-next-match
        execute-keys "ge %opt{gtag_current_line}g<a-l> /^\S+\s+\d+ \S+<ret>"
        gtag-jump
    }
    try %{ evaluate-commands -client %opt{toolsclient} %{ execute-keys gg %opt{gtag_current_line}g } }
}


declare-user-mode gtag

map global gtag d '<a-i>w:gtag-def <c-r>.<ret>'     -docstring 'find definition of selection'
map global gtag D ':gtag-def '                      -docstring 'find definition'
map global gtag r '<a-i>w:gtag-ref <c-r>.<ret>'     -docstring 'find reference of selection'
map global gtag R ':gtag-ref '                      -docstring 'find reference'
map global gtag g ':gtag-grep <c-r>.<ret>'          -docstring 'grep lines of selection'
map global gtag G ':gtag-grep '                     -docstring 'grep lines'
map global gtag f ':gtag-path '                     -docstring 'find file'
map global gtag [ ':gtag-previous-match<ret>'       -docstring 'go to previous match'
map global gtag ] ':gtag-next-match<ret>'           -docstring 'go to next match'

map global user g ': enter-user-mode gtag<ret>'     -docstring 'gtag mode'
