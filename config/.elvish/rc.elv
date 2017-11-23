# key bindings
edit:insert:binding[c-a] = edit:move-dot-sol
edit:insert:binding[c-e] = edit:move-dot-eol
edit:insert:binding[c-w] = edit:kill-word-left
edit:insert:binding[a-w] = edit:kill-small-word-left
edit:insert:binding[a-p] = edit:history:start
# Alt-d to delete the word under the cursor
edit:insert:binding[a-d] = { edit:move-dot-right-word; edit:kill-word-left }

edit:history:binding[a-p] = edit:history:up
edit:history:binding[a-n] = edit:history:down-or-quit


# abbreviates
edit:abbr['~A'] = /data/code/android/5.1
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

use completer:adb
use completer:git
use completer:ssh
