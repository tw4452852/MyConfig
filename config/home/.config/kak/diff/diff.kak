declare-option -docstring "diff command in shell" \
    str diffcmd 'diff -uN'
define-command -docstring 'Show diff between current buffer content and according file' \
d %{ evaluate-commands %sh{
        output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-diff.XXXXXXXX)/fifo
        buf=$(dirname $output)/buf 
        mkfifo ${output}
        printf %s\\n "
        	write -sync \"${buf}\"
            evaluate-commands %sh{
            	( ${kak_opt_diffcmd} \"${kak_quoted_buffile}\" \"${buf}\" > \"${output}\" 2>&1 ) > /dev/null 2>&1 < /dev/null &

        		printf '%s\\n' \"evaluate-commands -try-client '$kak_opt_toolsclient' %{
                   edit! -fifo ${output} -scroll *diff*
                   set-option buffer filetype diff
                   hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname ${output}) } }
        		}\"
           }"
    }
}
