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
		cd_topdir() {
	        dirname_buffer="${kak_buffile%/*}"
	        if [ "${dirname_buffer}" = "${kak_buffile}" ]; then
	            # If we're scratch buffer, use cwd
	            dirname_buffer=.
	        fi
	        cd "${dirname_buffer}" 2>/dev/null || {
	            printf 'fail find_file: unable to change the current working directory to: %s\n' "${dirname_buffer}"
	            return 1
	        }
	        git_topdir="$(git rev-parse --show-toplevel)"
	        if [ "${git_topdir}" != "${HOME}" ]; then
		        cd "${git_topdir}" 2>/dev/null || {
		            printf 'fail find_file: unable to change the current working directory to: %s\n' "${git_topdir}"
		            return 1
		        }
	        fi
	    }

		cd_topdir || exit
		line=$(fd --no-ignore -t f | fzf-tmux -p)
		if [ -n "$line" ]; then
			real_path="$(realpath $line)"
			printf "edit %s" $real_path
		fi
	}
}

map global user <space> ': find_in_buffer<ret>' -docstring 'find in current buffer'
map global user f ': find_file<ret>' -docstring 'find file'
