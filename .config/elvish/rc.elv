use epm
set E:LC_ALL = en_US.UTF-8
set E:GOPATH = ~/go
set E:FLUTTER_SDK = ~/code/flutter
set E:ANDROID_SDK_ROOT = ~/android-sdk
set E:CHROME_EXECUTABLE = google-chrome-stable
each {|p|
	if (not (has-value $paths $p)) {
		set paths = [ $@paths $p ]
	}
} [
	~/MyRoot/bin
	~/MyRoot/usr/bin
	$E:GOPATH/bin
	~/.local/bin
	$E:FLUTTER_SDK/bin/cache/dart-sdk/bin
	$E:FLUTTER_SDK/bin

]
# prefer editinacme
if (has-external editinacme) {
	set E:EDITOR = editinacme
} elif (has-external kak) {
	set E:EDITOR = kak
} elif (has-external nvim) {
	set E:CSCOPE_EDITOR = nvim
	set E:EDITOR = nvim
	set E:MANPAGER = "nvim -c 'set ft=man' -"
} elif (has-external vim) {
	set E:CSCOPE_EDITOR = vim
	set E:EDITOR = vim
	set E:MANPAGER = 'vim -R -'
} else {
	# leave as it is
}
if (has-external pt) {
	set E:FZF_DEFAULT_COMMAND = 'pt -l -g ".*"'
}
#E:MANPATH = (get-env MANPATH):{~}/MyRoot/usr/share/man

fn l {|@args|
	ls --color $@args
}

set edit:insert:binding[C-a] = $edit:move-dot-sol~
set edit:insert:binding[C-e] = $edit:move-dot-eol~
set edit:insert:binding[A-h] = $edit:move-dot-left~
set edit:insert:binding[A-j] = $edit:move-dot-down~
set edit:insert:binding[A-k] = $edit:move-dot-up~
set edit:insert:binding[A-l] = $edit:move-dot-right~
set edit:insert:binding[A-w] = $edit:kill-small-word-left~
set edit:insert:binding[A-p] = $edit:history:start~
set edit:insert:binding[A-d] = { edit:move-dot-right-word; edit:kill-word-left }
set edit:insert:binding[C-x] = { edit:-instant:start }
set edit:insert:binding[A-t] = $edit:transpose-word~
set edit:insert:binding[A-/] = { var @args = (edit:wordify $edit:current-command); edit:insert-at-dot $args[-1] }
set edit:history:binding[A-p] = $edit:history:up~
set edit:history:binding[A-n] = $edit:history:down-or-quit~

# pin previous cwp to facilitate jumping back
set before-chdir = [
	{|_|
		set edit:location:pinned = [$pwd]
	}
]

# set window title for tmux
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-modules
use github.com/zzamboni/elvish-modules/terminal-title
set terminal-title:title-during-command = {|cmd|
  put $cmd" | "(tilde-abbr $pwd)
}

# notify when long-run command finish
epm:install &silent-if-installed=$true github.com/krader1961/elvish-lib
use github.com/krader1961/elvish-lib/cmd-duration
set edit:after-command = [ $@edit:after-command
	{|m|
		if (>= $m[duration] 1.0) {
			if (has-external notify-send) {
				notify-send $m[src][code] 'took '(cmd-duration:human-readable $m[duration])
			}
		}
	}
]

epm:install &silent-if-installed=$true github.com/tw4452852/elvish-completions
epm:install &silent-if-installed=$true github.com/xiaq/edit.elv

use github.com/xiaq/edit.elv/smart-matcher; smart-matcher:apply
use github.com/tw4452852/elvish-completions/common
use github.com/tw4452852/elvish-completions/git
use github.com/tw4452852/elvish-completions/ssh
use github.com/tw4452852/elvish-completions/cd
use github.com/tw4452852/elvish-completions/builtins