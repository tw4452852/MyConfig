evaluate-commands %sh{
    if ! command -v youdao-translation > /dev/null 2>&1; then
        echo "echo -debug youdao-translation is not installed"
    fi
}

define-command yd -docstring "translate with youdao-translation" \
-params 1 %{
    nop %sh{{
        	output=$(youdao-translation $1 | sed '1d')
        	printf "evaluate-commands -client $kak_client info -title $1 '%%{${output}}'" | kak -p ${kak_session}
    	} > /dev/null 2>&1 < /dev/null &
    }
}

map global user t '<a-i>w: yd %val{selection}<ret>' -docstring 'translate current selection'
