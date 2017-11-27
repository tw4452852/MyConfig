# Fetch list of valid git commands and aliases from git itself
-git-cmds = [
  ((resolve git) help -a | grep '^  [a-z]' | tr -s "[:blank:]" "\n" | each [x]{ if (> (count $x) 0) { put $x } })
  ((resolve git) config --list | grep alias | sed 's/^alias\.//; s/=.*$//')
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
    # From https://github.com/occivink/config/blob/master/.elvish/rc.elv
    subcommand = $rest[0]
    if (or (eq $subcommand add) (eq $subcommand stage) (eq $subcommand di)) {
      -run-git-cmd $gitcmd diff --name-only
      -run-git-cmd $gitcmd ls-files --others --exclude-standard
    } elif (or (eq $subcommand checkout) (eq $subcommand co)) {
      -run-git-cmd $gitcmd for-each-ref  --format="%(refname:short)"
      -run-git-cmd $gitcmd diff --name-only
    } elif (or (eq $subcommand mv) (eq $subcommand rm) (eq $subcommand diff) (eq $subcommand lg) (eq $subcommand log)) {
      -run-git-cmd $gitcmd ls-files
    }
  }
}

edit:arg-completer[git] = [@args]{ -git-completer e:git (explode $args[1:]) }
