# environment variables#{{{
E:LC_ALL = en_US.UTF-8
E:GOPATH = ~/go
E:FLUTTER_SDK = ~/code/flutter
E:ANDROID_SDK_ROOT = ~/android-sdk
E:CHROME_EXECUTABLE = google-chrome-stable
each [p]{
	if (not (has-value $paths $p)) {
		paths = [ $@paths $p ]
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
	E:EDITOR = editinacme
} elif (has-external kak) {
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
#E:MANPATH = (get-env MANPATH):{~}/MyRoot/usr/share/man
#}}}
fn l [@args]{
	ls --color $@args
}
# key bindings#{{{
edit:insert:binding[C-a] = $edit:move-dot-sol~
edit:insert:binding[C-e] = $edit:move-dot-eol~
edit:insert:binding[A-w] = $edit:kill-small-word-left~
edit:insert:binding[A-p] = $edit:history:start~
# Alt-d to delete the word under the cursor
edit:insert:binding[A-d] = { edit:move-dot-right-word; edit:kill-word-left }
edit:insert:binding[C-x] = { edit:-instant:start }

edit:history:binding[A-p] = $edit:history:up~
edit:history:binding[A-n] = $edit:history:down-or-quit~
#}}}
# abbreviates#{{{
edit:abbr['~A'] = /data/code/android/5.1
edit:abbr['~T'] = ~/tmp
edit:abbr['~P'] = ~/public/android/5.1
#}}}

# pin previous cwp to facilitate jumping back
before-chdir = [
	[_]{
		edit:location:pinned = [$pwd]
	}
]
#}}}
# completion#{{{
edit:completion:matcher[''] = [x]{ edit:match-prefix &ignore-case=$true $x }

use epm
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions
epm:install &silent-if-installed=$true github.com/tw4452852/elvish-completions
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-modules

use github.com/zzamboni/elvish-modules/terminal-title
terminal-title:title-during-command = [cmd]{
  put $cmd" | "(tilde-abbr $pwd)
}

use github.com/tw4452852/elvish-completions/common
use github.com/tw4452852/elvish-completions/adb
use github.com/tw4452852/elvish-completions/sudo
use github.com/zzamboni/elvish-completions/git
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/builtins

#}}}
# vim: set fdm=marker sw=4 ts=4 ft=sh:
