# environment variables#{{{
E:LC_ALL = en_US.UTF-8
E:GOROOT = ~/goroot
E:GOPATH = ~/go
each [p]{
	if (not (has-value $paths $p)) {
		paths = [ $@paths $p ]
	}
} [
	~/MyRoot/bin
	~/MyRoot/usr/bin
	$E:GOROOT/bin
	$E:GOPATH/bin
	~/.local/bin
]
# prefer neovim
if (has-external kak) {
	E:EDITOR = kak
} elif (has-external nvim) {
	E:CSCOPE_EDITOR = nvim
	E:EDITOR = nvim
	E:MANPAGER = "nvim -c 'set ft=man' -"
} elif (has-external vim) {
	E:CSCOPE_EDITOR = vim
	E:EDITOR = vim
	E:MANPAGER = 'vim -R -'
} else {
	# leave as it is
}
if (has-external pt) {
	E:FZF_DEFAULT_COMMAND = 'pt -l -g ".*"'
}
E:MANPATH = (get-env MANPATH):{~}/MyRoot/usr/share/man
#}}}
fn l [@args]{
	ls --color $@args
}
# key bindings#{{{
edit:insert:binding[c-a] = $edit:move-dot-sol~
edit:insert:binding[c-e] = $edit:move-dot-eol~
edit:insert:binding[c-w] = $edit:kill-word-left~
edit:insert:binding[a-w] = $edit:kill-small-word-left~
edit:insert:binding[a-p] = $edit:history:start~
# Alt-d to delete the word under the cursor
edit:insert:binding[a-d] = { edit:move-dot-right-word; edit:kill-word-left }

edit:history:binding[a-p] = $edit:history:up~
edit:history:binding[a-n] = $edit:history:down-or-quit~
#}}}
# abbreviates#{{{
edit:abbr['~A'] = /data/code/android/5.1
edit:abbr['~T'] = ~/tmp
edit:abbr['~P'] = ~/public/android/5.1
#}}}

tmux_window_id = (tmux display-message -p '#I')
# hooks#{{{
edit:before-readline = [
	{
		# window's name
		tmux rename-window -t $tmux_window_id elvish
	}
]
edit:after-readline = [
	[cmdline]{
		cmds = [(edit:wordify $cmdline)]
		if (> (count $cmds) 0) {
			cmd = $cmds[0]

			# explore the real cmdline
			if (==s $cmd fg) {
				p = $cmds[1]
				cmdline = (replaces (cat /proc/$p/cmdline)[:-1] "\x00" ' ')
				cmds = [(edit:wordify $cmdline)]
				cmd = (cat /proc/$p/comm)
			}

			# window's name
			tmux rename-window -t $tmux_window_id $cmd
			# pannel's title
			tmux select-pane -T $cmdline
		}
	}
]

# pin previous cwp to facilitate jumping back
before-chdir = [
	[_]{
		edit:location:pinned = [$pwd]
	}
]
#}}}
# completion#{{{
edit:completion:matcher[''] = [x]{ edit:match-prefix &ignore-case=$true $x }
edit:location:matcher = [x]{ edit:location:match-dir-pattern &ignore-case=$true $x }

use epm
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions

use completer/common
use completer/adb
use github.com/zzamboni/elvish-completions/git
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/builtins

#}}}
# vim: set fdm=marker sw=4 ts=4 ft=sh:
