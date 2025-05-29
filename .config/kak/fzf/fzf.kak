define-command -hidden find_in_buffer %{
	execute-keys %sh{
		echo "write $kak_response_fifo" > $kak_command_fifo
		line=$(grep -n . $kak_response_fifo | fzf-tmux -p | cut -d : -f 1)
		if [ -n "$line" ]; then
			printf "%sg" $line
		fi
	}
}

define-command -hidden find_file %{
	evaluate-commands %sh{
		line=$(fd --no-ignore -t f | fzf-tmux -p)
		if [ -n "$line" ]; then
			printf "edit %s" $line
		fi
	}
}

map global user <space> ': find_in_buffer<ret>' -docstring 'find in current buffer'
map global user f ': find_file<ret>' -docstring 'find file'
