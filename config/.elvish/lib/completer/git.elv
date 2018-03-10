# Fetch list of valid git commands and aliases from git itself
-git-cmds = [
  ( e:git help -a | grep '^  [a-z]' | tr -s "[:blank:]" "\n" | each [x]{ if (> (count $x) 0) { put $x } })
  ( e:git config --list | grep alias | sed 's/^alias\.//; s/=.*$//')
]
-git-commands = [(echo &sep="\n" $@-git-cmds | sort)]

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

fn -git-completer [gitcmd @rest]{
	n = (count $rest)
	if (eq $n 1) {
		put $@-git-commands
	} else {
		subcommand = $rest[0]

		# only show refs
		if (or (eq $subcommand push) (eq $subcommand pull) (eq $subcommand rebase) (eq $subcommand rb) (eq $subcommand branch) (eq $subcommand br)) {
			-run-git-cmd $gitcmd for-each-ref  --format="%(refname:short)"
			return
		}

		# only show files
		if (or (eq $subcommand diff) (eq $subcommand di) (eq $subcommand mv) (eq $subcommand rm) (eq $subcommand add) (eq $subcommand stage) (eq $subcommand sa)) {
			-run-git-cmd $gitcmd status --porcelain -s | peach [x]{ put [(splits " " $x[3:])][0] }
			return
		}

		# only show refs and files
		if (or (eq $subcommand checkout) (eq $subcommand co) (eq $subcommand log) (eq $subcommand lg)) {
			-run-git-cmd $gitcmd for-each-ref  --format="%(refname:short)"
			-run-git-cmd $gitcmd status --porcelain -s | peach [x]{ put [(splits " " $x[3:])][0] }
			return
		}

		edit:complete-filename $@rest
	}
}

edit:completion:arg-completer[git] = [@args]{ -git-completer e:git (explode $args[1:]) }

# vim: set fdm=marker sw=4 ts=4 ft=sh:
