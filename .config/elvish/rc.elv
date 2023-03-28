# environment variables#{{{
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
#}}}
fn l {|@args|
	ls --color $@args
}
# key bindings#{{{
set edit:insert:binding[C-a] = $edit:move-dot-sol~
set edit:insert:binding[C-e] = $edit:move-dot-eol~
set edit:insert:binding[A-h] = $edit:move-dot-left~
set edit:insert:binding[A-j] = $edit:move-dot-down~
set edit:insert:binding[A-k] = $edit:move-dot-up~
set edit:insert:binding[A-l] = $edit:move-dot-right~
set edit:insert:binding[A-w] = $edit:kill-small-word-left~
set edit:insert:binding[A-p] = $edit:history:start~
# Alt-d to delete the word under the cursor
set edit:insert:binding[A-d] = { edit:move-dot-right-word; edit:kill-word-left }
set edit:insert:binding[C-x] = { edit:-instant:start }
set edit:insert:binding[A-t] = $edit:transpose-word~

set edit:history:binding[A-p] = $edit:history:up~
set edit:history:binding[A-n] = $edit:history:down-or-quit~
#}}}
# abbreviates#{{{
set edit:abbr['~A'] = /data/code/android/5.1
set edit:abbr['~T'] = ~/tmp
set edit:abbr['~P'] = ~/public/android/5.1
#}}}

# pin previous cwp to facilitate jumping back
set before-chdir = [
	{|_|
		set edit:location:pinned = [$pwd]
	}
]
#}}}

# notify when long-run command finish
set edit:after-command = [ $@edit:after-command
	{|m|
		if (>= $m[duration] 1.0) {
			notify-send $m[src][code] 'took '$m[duration]' seconds'
		}
	}
]

# completion#{{{
set edit:completion:matcher[''] = {|x| edit:match-prefix &ignore-case=$true $x }

use epm
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions
epm:install &silent-if-installed=$true github.com/tw4452852/elvish-completions
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-modules
epm:install &silent-if-installed=$true github.com/xiaq/edit.elv

use github.com/zzamboni/elvish-modules/terminal-title
set terminal-title:title-during-command = {|cmd|
  put $cmd" | "(tilde-abbr $pwd)
}

use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply
use github.com/tw4452852/elvish-completions/adb
use github.com/tw4452852/elvish-completions/sudo
use github.com/zzamboni/elvish-completions/git
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/builtins

#}}}
# vim: set fdm=marker sw=4 ts=4 ft=sh:
