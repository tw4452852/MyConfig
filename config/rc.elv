use re

# key bindings
edit:insert:binding[c-a] = edit:move-dot-sol
edit:insert:binding[c-e] = edit:move-dot-eol
edit:insert:binding[c-w] = edit:kill-word-left
edit:insert:binding[a-w] = edit:kill-small-word-left
edit:insert:binding[a-p] = edit:history:start
edit:history:binding[a-p] = edit:history:up
edit:history:binding[a-n] = edit:history:down-or-quit

# abbreviates
edit:abbr['~A'] = ~/code/android/5.1
edit:abbr['~T'] = ~/tmp
edit:abbr['~P'] = ~/public/android/5.1

# hooks
edit:before-readline = [
	{
		# window's name
		print "\033kelvish\033\\"
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
			print "\033k"$cmd"\033\\"
			# pannel's title
			print "\033]2;"$cmdline"\033\\"
		}
	}
]

# completion
edit:-matcher[''] = [x]{ edit:match-prefix &smart-case=$true $x }

edit:arg-completer[adb] = [@a]{
	os = [-s -p]
	cs = [put devices connect disconnect sync shell emu logcat forward help version wait-for-device start-server kill-server get-state get-serialno get-devpath status-window remount reboot reboot-bootloader root usb tcpip ppp reverse jdwp install uninstall bugreport backup restore disable-verity keygen push pull]

	n = (count $a)
	hasCmd = $false

	each [x]{ if (has-value $cs $x) { hasCmd = $true ; break } } $a

	if (>= $n 2) {
		if (==s $a[-1] -) {
			put $@os
		} elif (or (==s $a[-2] -s) (==s $a[-2] disconnect)) {
			e:adb devices | eawk [@fields]{ if (or (==s $fields[1] List) (==s $fields[1] '')) { continue }; put $fields[1] }
		} elif (re:match /system/ $a[-2]) {
			re:find /system/ $a[-2] | each [x]{ put $a[-2][$x[start]:] }
		} elif (not $hasCmd) {
			put $@cs
		} else {
			edit:complete-filename $@a
		}
	} else {
		edit:complete-filename $@a
	}
}


# Fetch list of valid git commands and aliases from git itself
-git-cmds = [
  ((resolve git) help -a | grep '^  [a-z]' | tr -s "[:blank:]" "\n" | each [x]{ if (> (count $x) 0) { put $x } })
  ((resolve git) config --list | grep alias | sed 's/^alias\.//; s/=.*$//')
]
git-commands = [(echo &sep="\n" $@-git-cmds | sort)]

# This allows $gitcmd to be a multi-word command and still be executed
# correctly. We cannot simply run "$gitcmd <opts>" because Elvish always
# interprets the first token (the head) to be the command.
# One example of a multi-word $gitcmd is "vcsh <repo>", after which
# any git subcommand is valid.
fn -run-git-cmd [gitcmd @rest]{
  gitcmds = [$gitcmd]
  if (eq (kind-of $gitcmd) string) {
    gitcmds = [(splits " " $gitcmd)]
  }
  if (> (count $gitcmds) 1) {
    $gitcmds[0] (explode $gitcmds[1:]) $@rest
  } else {
    $gitcmds[0] $@rest
  }
}

fn git-completer [gitcmd @rest]{
  n = (count $rest)
  if (eq $n 1) {
    put $@git-commands
  } else {
    # From https://github.com/occivink/config/blob/master/.elvish/rc.elv
    subcommand = $rest[0]
    if (or (eq $subcommand add) (eq $subcommand stage) (eq $subcommand di)) {
      -run-git-cmd $gitcmd diff --name-only
      -run-git-cmd $gitcmd ls-files --others --exclude-standard
    } elif (or (eq $subcommand checkout) (eq $subcommand co)) {
      -run-git-cmd $gitcmd for-each-ref  --format="%(refname:short)"
      -run-git-cmd $gitcmd diff --name-only
    } elif (or (eq $subcommand mv) (eq $subcommand rm) (eq $subcommand diff)) {
      -run-git-cmd $gitcmd ls-files
    }
  }
}
edit:arg-completer[git] = [@args]{ git-completer e:git (explode $args[1:]) }
