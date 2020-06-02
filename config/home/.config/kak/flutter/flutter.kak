declare-option -hidden str flutter_dir %sh{ echo "${TMPDIR:-/tmp}/kak-${kak_session}-flutter" }
declare-option str flutter_device

define-command flutter-run-init %{
	evaluate-commands %sh{
		[ -r ${kak_opt_flutter_dir}/pid ] && exit 0;
		mkdir ${kak_opt_flutter_dir}
		mkfifo ${kak_opt_flutter_dir}/fifo
		( flutter -d "${kak_opt_flutter_device}" run --pid-file=${kak_opt_flutter_dir}/pid > ${kak_opt_flutter_dir}/fifo 2>&1 & ) > /dev/null 2>&1 < /dev/null
		printf %s\\n 'evaluate-commands -try-client "%opt{toolsclient}" %{
			edit! -fifo "%opt{flutter_dir}/fifo" -scroll *flutter*
			hook -always -once buffer BufCloseFifo .* %{
				echo -debug %sh{
					kill "$(cat ${kak_opt_flutter_dir}/pid)"
					rm -fr '${kak_opt_flutter_dir}'
				}
			}
		}'
	}
}

define-command -hidden flutter-hot-reload %{
	flutter-run-init
	evaluate-commands -try-client %opt{toolsclient} %{ buffer *flutter*; execute-keys 'ge' }
	nop %sh{
		kill -USR1 $(cat ${kak_opt_flutter_dir}/pid)
	}
}

define-command -hidden flutter-hot-restart %{
	flutter-run-init
	evaluate-commands -try-client %opt{toolsclient} %{ buffer *flutter*; execute-keys 'ge' }
	nop %sh{
		kill -USR2 $(cat ${kak_opt_flutter_dir}/pid)
	}
}

define-command -hidden flutter-format %{
	nop %sh{
		flutter format .
	}
}

declare-user-mode flutter
map global flutter r ': flutter-hot-reload<ret>' -docstring "reload"
map global flutter R ': flutter-hot-restart<ret>' -docstring "restart"
map global flutter f ': flutter-format<ret>' -docstring "format"

hook global KakBegin .* %{
	evaluate-commands %sh{
		[ -f $PWD/pubspec.yaml ] && printf %s\\n "map global user f ': enter-user-mode flutter<ret>' -docstring 'flutter mode'"
	}
}
