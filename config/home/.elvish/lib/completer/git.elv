# Fetch list of valid git commands and aliases from git itself
-git-cmds = [
  ( e:git help -a | grep '^  [a-z]' | tr -s "[:blank:]" "\n" | each [x]{ if (> (count $x) 0) { put $x } })
  ( e:git config --list | grep alias | sed 's/^alias\.//; s/=.*$//')
]
-git-commands = [(echo &sep="\n" $@-git-cmds | sort)]

fn -git-completer [@args]{
	n = (count $args)
	if (<= $n 2) {
		put $@-git-commands
	} else {
		subcommand = $args[1]

		# only show refs
		if (or (eq $subcommand push) \
			(eq $subcommand pull) \
			(eq $subcommand rebase) (eq $subcommand rb) \
			(eq $subcommand branch) (eq $subcommand br) \
			(eq $subcommand cherry) \
			(eq $subcommand cherry-pick)) {
			e:git for-each-ref  --format="%(refname:short)"
			return
		}

		# only show files
		if (or (eq $subcommand diff) (eq $subcommand di) \
			(eq $subcommand mv) \
			(eq $subcommand rm) \
			(eq $subcommand add) \
			(eq $subcommand stage) (eq $subcommand sa)) {
			e:git status --porcelain -s | peach [x]{ put [(splits " " $x[3:])][0] }
			return
		}

		# only show refs and files
		if (or (eq $subcommand checkout) (eq $subcommand co) \
			(eq $subcommand log) (eq $subcommand lg)) {
			e:git for-each-ref  --format="%(refname:short)"
			e:git status --porcelain -s | peach [x]{ put [(splits " " $x[3:])][0] }
		}

		edit:complete-filename $@args
	}
}

edit:completion:arg-completer[git] = $-git-completer~

# vim: set fdm=marker sw=4 ts=4 ft=sh:
