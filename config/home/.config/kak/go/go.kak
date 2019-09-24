declare-option -hidden int guru_current_line 0

declare-option -hidden regex guru_style_1 '^([^:\n]+):(\d+).(\d+)[^:]+:'
declare-option -hidden regex guru_style_2 '^([^:\n]+):(\d+):(\d+):'

define-command -hidden -params 1 goguru-cmd %{
   evaluate-commands %sh{
       output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-go.XXXXXXXX)/fifo
       mkfifo ${output}
       ( cd ${kak_buffile%/*} && guru -scope . $1 "${kak_buffile}:#${kak_cursor_byte_offset}" > ${output} 2>&1 ) > /dev/null 2>&1 < /dev/null &
       printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
           edit! -fifo ${output} -scroll *guru*
           set-option buffer filetype guru
           set-option buffer guru_current_line 0
           hook -always -once buffer BufCloseFifo .* %{ evaluate-commands %sh{ rm -r ${output%/*} }}
       }"
   }
}
hook -group guru-highlight global WinSetOption filetype=guru %{
    add-highlighter window/guru group
    add-highlighter window/guru/ regex %opt{guru_style_1} 1:cyan 2:green 3:red
    add-highlighter window/guru/ regex %opt{guru_style_2} 1:cyan 2:green 3:red
    add-highlighter window/guru/ line %{%opt{guru_current_line}} default+b
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/guru }
}

hook global WinSetOption filetype=guru %{
    hook buffer -group guru-hooks NormalKey <ret> guru-jump
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks buffer guru-hooks }
}

define-command -hidden guru-jump %{
    evaluate-commands %{ # use evaluate-commands to ensure jumps are collapsed
        try %{
            try %{ execute-keys "<a-x>s%opt{guru_style_1}<ret>"
            } catch %{ execute-keys "<a-x>s%opt{guru_style_2}<ret>" } 
            set-option buffer guru_current_line %val{cursor_line}
            evaluate-commands -try-client %opt{jumpclient} edit -existing %reg{1} %reg{2} %reg{3}
            try %{ focus %opt{jumpclient} }
        }
    }
}

define-command guru-next-match -docstring 'Jump to the next guru match' %{
    evaluate-commands -try-client %opt{jumpclient} %{
        buffer '*guru*'
        # First jump to enf of buffer so that if guru_current_line == 0
        # 0g<a-l> will be a no-op and we'll jump to the first result.
        # Yeah, thats ugly...
        execute-keys "ge %opt{guru_current_line}g<a-l> /^[^:]+:\d+<ret>"
        guru-jump
    }
    try %{ evaluate-commands -client %opt{toolsclient} %{ execute-keys gg %opt{guru_current_line}g } }
}

define-command guru-previous-match -docstring 'Jump to the previous guru match' %{
    evaluate-commands -try-client %opt{jumpclient} %{
        buffer '*guru*'
        # See comment in guru-next-match
        execute-keys "ge %opt{guru_current_line}g<a-h> <a-/>^[^:]+:\d+<ret>"
        guru-jump
    }
    try %{ evaluate-commands -client %opt{toolsclient} %{ execute-keys gg %opt{guru_current_line}g } }
}

declare-user-mode guru
map global guru e ': goguru-cmd callees<ret>'           -docstring "show possible targets of selected function call"
map global guru c ': goguru-cmd callers<ret>'           -docstring "show possible callers of selected function"
map global guru s ': goguru-cmd callstack<ret>'         -docstring "show path from callgraph root to selected function"
# map global guru d ': goguru-cmd definition<ret>'      -docstring "show declaration of selected identifier"
map global guru d ': goguru-cmd describe<ret>'          -docstring "describe selected syntax: definition, methods, etc"
# map global guru f ': goguru-cmd freevars<ret>'        -docstring "show free variables of selection"
map global guru i ': goguru-cmd implements<ret>'        -docstring "show 'implements' relation for selected type or method"
map global guru p ': goguru-cmd peers<ret>'             -docstring "show send/receive corresponding to selected channel op"
# map global guru p ': goguru-cmd pointsto<ret>'        -docstring "show variables the selected pointer may point to"
map global guru r ': goguru-cmd referrers<ret>'         -docstring "show all refs to entity denoted by selected identifier"
# map global guru w ': goguru-cmd what<ret>'            -docstring "show basic information about the selected syntax node"
map global guru w ': goguru-cmd whicherrs<ret>'         -docstring "show possible values of the selected error variable"
map global guru [ ': guru-previous-match<ret>'          -docstring "jump to previous guru entry"
map global guru ] ': guru-next-match<ret>'              -docstring "jump to next guru entry"
 

hook global BufSetOption filetype=go %{
    echo -debug "BufferSetOption"
    set-option global make_error_pattern ''
    set-option buffer makecmd 'go build'
    map buffer user g ': enter-user-mode guru<ret>' -docstring 'guru mode'
}
# Use 'go test -c" for *_test.go files
hook global WinCreate .+_test\.go %{ set-option window makecmd 'go test -c' }
# Auto formatting before writing
hook global BufWritePre .*\.go %{ go-format -use-goimports }

