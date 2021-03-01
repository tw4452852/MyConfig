declare-option str notmuch_thread_client tools
declare-option str notmuch_last_search

define-command notmuch -params 1.. \
    -shell-script-candidates %{
        notmuch search --output=tags \* | sed -e 's/^/tag:/'
        printf "and\nor\n\\(\n\\)\n"
    } \
%{
    edit! -scratch *notmuch*
    execute-keys "!notmuch search %arg{@}<ret>gg"
    add-highlighter buffer/ line '%val{cursor_line}' default+r
    add-highlighter buffer/ regex \
        '^(?<thread>thread:[0-9a-f]+) +(?<date>[^[]+) (?<count>\[\d+/\d+(?:\(\d+\))?\]) (?<names>[^;]*); (?<subject>[^\n]*) (?<tags>\([-\w ]*\))$' \
        thread:yellow date:blue count:cyan names:green tags:red
    add-highlighter buffer/ regex '^[^;]*; (?<subject>[^\n]*) \([-\w ]*\bunread\b[-\w ]*\)$' subject:+b

    set-option buffer readonly true
    set-option buffer scrolloff 3,0
    set-option buffer notmuch_last_search %arg{1}

    hook buffer NormalIdle .* %{ evaluate-commands -draft %{ try %{
        execute-keys <a-x>sthread:\S+<ret>
        evaluate-commands -try-client %opt{notmuch_thread_client} notmuch-show %val{selection}
    }}}

    map buffer normal a ':notmuch-tag -inbox<ret>'
}

define-command notmuch-tag -params 1.. %{
    execute-keys <a-x>sthread:\S+<ret>
    nop %sh{notmuch tag "$@" -- $kak_selection}
    notmuch-update
}

define-command notmuch-update %{
    # Save current thread
    try %{ execute-keys <a-x>s 'thread:[0-9a-f]+' <ret>"a* } catch %{ set-register a . }
    # Save next thread in case current thread will not be in results anymore
    try %{ execute-keys j<a-x>s 'thread:[0-9a-f]+' <ret>"b* } catch %{ set-register b . }

    notmuch %opt{notmuch_last_search}
    # Select current or next thread
    try %{ execute-keys /<c-r>a<ret> vv } catch %{ execute-keys /<c-r>b<ret> vv }
}

define-command notmuch-apply-to -params 3 %[ evaluate-commands -draft %[ try %[
    set-register slash ''
    execute-keys s "\f%arg{1}\{" <ret> <a-x><a-k> "%arg{2}" <ret>
    evaluate-commands -itersel %[
        execute-keys }c "\f%arg{1}\{,\f%arg{1}\}" <ret>
        evaluate-commands %arg{3}
    ]
]]]

define-command -hidden notmuch-tree-fix-character %{
    try %{
        execute-keys <a-k>└<ret> r├
    } catch %{
        execute-keys <a-k>─<ret> r┬
    } catch %{
        execute-keys <a-k><space><ret> r│k
        notmuch-tree-fix-character
    } catch %{}
}

define-command -hidden notmuch-tree-insert-fixed-length -params 2 %{
    evaluate-commands -draft %{
        buffer *notmuch-tree-scratch*
        set-register dquote %arg{1}
        set-register a ' ' 
        execute-keys '%<a-d>' P %arg{2} '"aP' <a-O>k %arg{2} '"aP' hj<a-h>"ay
    }
    execute-keys '"aP'
}

declare-option -hidden line-specs notmuch_tree_message_ids
declare-option -hidden str-list notmuch_tree_restore_ids

define-command notmuch-tree-tag -params 1.. %{
    nop %sh{
        tags="$@"
        eval "set -- $kak_quoted_opt_notmuch_tree_message_ids"
        shift $kak_cursor_line
        thread="$(notmuch search --output=threads -- id:${1##*|})"
        if [ -n "$thread" ]; then
            notmuch tag "$tags" -- $thread
        fi
    }
    notmuch-tree-update
}

define-command notmuch-tree-update %{
    evaluate-commands %sh{
        eval "set -- $kak_quoted_opt_notmuch_tree_message_ids"
        shift $kak_cursor_line
        id=${1##*|}
        thread="$(notmuch search --output=threads -- id:$id)"
        for message; do
            if [ "$(notmuch search --output=threads -- id:${message##*|})" != "$thread" ]; then
                next_id=${message##*|}
                break
            fi
        done
        echo "set global notmuch_tree_restore_ids $id $next_id"
    }
    notmuch-tree %opt{notmuch_last_search}
    execute-keys %sh{
        eval "set -- $kak_quoted_opt_notmuch_tree_restore_ids"
        id=$1
        next_id=$2
        eval "set -- $kak_quoted_opt_notmuch_tree_message_ids"
        for message; do
            if [ "${message##*|}" == "$id" -o "${message##*|}" == "$next_id" ]; then
                echo "${message%%|*}g"
                break
            fi
        done
    }
}

define-command notmuch-tree -params 1 %[
    edit -scratch *notmuch-tree-scratch*
    edit! -scratch *notmuch-tree*
    execute-keys "!notmuch show --entire-thread --body=false --format=text '%arg{@}'<ret>"
    evaluate-commands -draft -no-hooks %[
        set-option buffer notmuch_tree_message_ids
        try %[ execute-keys \%s [^\n]\f\w+[{}] <ret> '<a-;>;a<ret><esc>' ] # Ensure all markers are on their own line
        execute-keys '%'
        notmuch-apply-to message '' %{
            evaluate-commands -draft %{ try %{
                execute-keys <a-k> '^\fheader\{\n[^\n]+\([^\n]+?\)[^\n]+\(([\w -]*\bunread\b[\w -]*)\)' <ret><a-semicolon> # }
                add-highlighter buffer/ line %val{cursor_line} +b
            }}
            execute-keys s '\fmessage\{.*id:(\H+).*\bdepth:(\d+).*\fheader\{\n[^\n]+\(([^\n]+?)\)[^\n]+\(([^\n]*?)\).*^Subject: ([^\n]*).*^From: ([^\n]+).*^Date: ([^\n]+).*\fheader\}.*\fmessage\}' <ret>"5R
            set-option -add buffer notmuch_tree_message_ids "%val{cursor_line}|%reg{1}"
            evaluate-commands -draft %{
                notmuch-tree-insert-fixed-length %reg{6} 40
                notmuch-tree-insert-fixed-length '' 1
                notmuch-tree-insert-fixed-length %reg{4} 15
                notmuch-tree-insert-fixed-length '' 1
                notmuch-tree-insert-fixed-length %reg{3} 12
                execute-keys 'i<space><esc>h"2R'
                try %{
                    execute-keys <a-k>\A0\z<ret>
                    execute-keys c '───╼ ' <esc>
                } catch %{
                    set-register a '  '
                    execute-keys %reg{2} '"aP' c '└──╼ ' <esc> 5hk
                    notmuch-tree-fix-character
                }
            }
        }
        hook buffer NormalIdle .* %{ evaluate-commands -draft %{ try %{
            evaluate-commands -try-client %opt{notmuch_thread_client} %sh{
                eval "set -- $kak_quoted_opt_notmuch_tree_message_ids"
                shift $kak_cursor_line
                id="${1##*|}"
                if [ -n "$id" ]; then
                    echo "notmuch-show id:$id"
                fi
            }
        }}}
    ]
    delete-buffer *notmuch-tree-scratch*
    execute-keys gg

    set-option buffer readonly true
    set-option buffer scrolloff 3,0
    set-option buffer notmuch_last_search %arg{1}

    add-highlighter buffer/regions regions
    add-highlighter buffer/regions/from region ^ ^.{40}\K group
    add-highlighter buffer/regions/from/ fill green
    add-highlighter buffer/regions/from/ regex <[^>]+>? 0:magenta
    add-highlighter buffer/regions/tags region ^.{41}\K ^.{56}\K fill red
    add-highlighter buffer/regions/date region ^.{57}\K ^.{69}\K fill blue

    add-highlighter buffer/ line '%val{cursor_line}' default+r

    map buffer normal a ':notmuch-tree-tag -inbox<ret>'
]

define-command notmuch-show -params 1 %[
    edit! -scratch *notmuch-show*
    execute-keys "!notmuch show --include-html --format=text '%arg{@}'<ret>gg"
    set-option buffer indentwidth 2
    evaluate-commands -draft %[
        try %[ execute-keys \%s [^\n]\f\w+[{}] <ret> '<a-;>;a<ret><esc>' ] # Ensure all markers are on their own line
        execute-keys '%'
        notmuch-apply-to part 'Content-type: multipart/(mixed|related)$' %{
            execute-keys <a-S><a-x>d
        }
        notmuch-apply-to part 'Content-type: multipart/alternative$' %{
            evaluate-commands -draft %[
                execute-keys 'K<a-;>J<a-x><a-:>'
                execute-keys s \fpart\{ <ret> }c \fpart\{,\fpart\} <ret>
                execute-keys -draft <a-k> '\A[^\n]+Content-type: text/html$' <ret>  # Ensure we have a text/html part
                execute-keys -draft <a-K> '\A[^\n]+Content-type: text/html$' <ret><a-x>d # Remove other parts
            ]
            execute-keys <a-S><a-x>d
        }
        notmuch-apply-to part 'Content-type: text/html$' %{
            execute-keys 'K<a-;>J<a-x>' '|w3m -dump -cols 120 -graph -T text/html -o display_link_number=true<ret>'
        }
        notmuch-apply-to header '' %[
            execute-keys <a-S><a-x>d<a-space>j<a-x>d
        ]
        notmuch-apply-to body '' %[
            execute-keys <a-S><a-x>d
        ]
        notmuch-apply-to part '' %[
            execute-keys -draft '<a-;>J<gt>'
            execute-keys -draft <a-S><space><a-x>d
            execute-keys -draft <a-S><a-space><a-x>s\fpart\{<ret>c '⬛ Part:' <esc>
        ]
        notmuch-apply-to attachment '' %[
            execute-keys -draft '<a-;>J<a-x>d'
            execute-keys -draft <a-x>s\fattachment\{<ret>c '⬛ Attachment:' <esc>
        ]
        notmuch-apply-to message '' %{
            execute-keys -draft 'K<a-;>J<a-x><gt>'
            execute-keys -draft ';<a-x>c<ret>'
            execute-keys '<a-;>;<a-x>s' id:\S+ <ret>"ay <a-x>Hc '⬛ Message: <c-r>a' <esc>

            add-highlighter buffer/ line %val{cursor_line} default+r
        }

        set-option buffer readonly true
    ]

    add-highlighter buffer/ regex ^\h*(From|To|Cc|Bcc|Subject|Reply-To|In-Reply-To|Date):([^\n]*)$ 1:keyword 2:attribute
    add-highlighter buffer/ regex <[^@>\s]+@.*?> 0:string
    add-highlighter buffer/ regex ^\h*>.*?$ 0:comment
    add-highlighter buffer/regions regions
    add-highlighter buffer/regions/diff region ^\h+---\h*$ ^\h+--\h*$ group
    add-highlighter buffer/regions/diff/ regex ^\h+@@[^\n]*$ 0:meta
    add-highlighter buffer/regions/diff/ regex ^\h+\+[^\n]*$ 0:green
    add-highlighter buffer/regions/diff/ regex ^\h+-[^\n]*$ 0:red

    add-highlighter buffer/ wrap -indent -word -marker ' ➥'

    nop %sh{ notmuch tag -unread "$1" }
]

define-command notmuch-reply -params 1 %[
    edit -scratch *notmuch-reply*
    set-option buffer filetype mail
    add-highlighter buffer/ wrap -word -width 120
    execute-keys "!notmuch reply '%arg{@}'<ret>"
]

define-command notmuch-save-part %{
    try %{
        evaluate-commands -save-regs abc %{
            evaluate-commands -draft %{
                execute-keys gl<a-/> '⬛ (?:Part|Attachment): ID: (\d+)(?:[^\n]+?Filename: ([^\n,]+))?(?:,|$)' <ret>
                set-register a %reg{1}
                set-register b %reg{2}
                execute-keys gl<a-/> '⬛ (?:Message): (id:\S+)' <ret>
                set-register c %reg{1}
            }
            prompt "save part %reg{a} of message %reg{c} to: " -init "%reg{b}" \
                   "nop %%sh{ notmuch show --part %reg{a} %reg{c} > ""$kak_text"" }"
        }
    } catch %{
        echo -markup "{Error}Could not determine current part and message"
    }
}

declare-user-mode notmuch
map global notmuch u ': notmuch-update<ret>'           -docstring "update"
map global notmuch q ': notmuch '                      -docstring "query"
map global user n ': enter-user-mode notmuch<ret>'     -docstring 'notmuch mode'
