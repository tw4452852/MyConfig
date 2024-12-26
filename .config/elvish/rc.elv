use epm
use os
use str
use path

set E:LC_ALL = en_US.UTF-8
set E:GOPATH = ~/go
set E:FLUTTER_SDK = ~/code/flutter
set E:ANDROID_SDK_ROOT = ~/android-sdk
set E:CHROME_EXECUTABLE = google-chrome-stable
set E:XDEB_PKGROOT = ~/.config/xdeb
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
# prefer kakoune editor
if (has-external kak) {
	set E:EDITOR = kak
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

# git commit explorer
fn gce {
  try {
    var sha = (fzf --ansi --layout=reverse-list +s --with-shell 'elvish -c' ^
      --preview-window=wrap --preview ' ^
        use re; ^
        use str; ^
        each {|x| ^
          if (re:match "^[0-9a-f]\{5,40}$" $x) { ^
           git show --color $x ^
          } ^
        } [(str:fields (slurp < {f}))] ' | grep -o -E -e '[0-9a-f]{5,40}' | take 1)
    edit:insert-at-dot ' '$sha
  } catch {
    nop
  }
}
set edit:insert:binding[C-g] = {
  var cmd = "git lg"
  if (str:has-prefix $edit:current-command "git news") {
    set cmd = $edit:current-command
  }
  eval $cmd | gce > $os:dev-tty 2>&1
}

# fuzzy path finder
fn fpf {|root|
  try {
    var can = (tmp pwd = $root; fzf +m --walker=file,dir,follow,hidden < $os:dev-tty)
    edit:insert-at-dot ./$can
  } catch {
    nop
  }
}
set edit:insert:binding[C-d] = {
 try {
  var root = .
  if (!=s $edit:current-command[-1] ' ') {
    var last = (str:replace '~' $E:HOME [(edit:wordify $edit:current-command)][-1])
    if (path:is-dir $last) {
      set root = $last
    }
  }
  fpf $root > $os:dev-tty 2>&1
 } catch {
   nop
 }
}

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

epm:install &silent-if-installed=$true github.com/xiaq/edit.elv

fn match {|seed|
  var inputs = [(all)]
  var results = [(to-lines $inputs | try { e:fzf -0 -1 --no-sort -f $seed } catch { nop } )]
  each {|x|
    if (has-value $results $x) {
      put $true
    } else {
      put $false
    }
  } $inputs
}
#set edit:completion:matcher[''] = $match~
use github.com/xiaq/edit.elv/smart-matcher; smart-matcher:apply

set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
set-env CARAPACE_MATCH 1  # case insensitive
eval (carapace _carapace|slurp)

set edit:abbr['~config'] = '~/.config'
set edit:command-abbr['gti'] = 'git'
