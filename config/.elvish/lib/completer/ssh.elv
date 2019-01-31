use re
use completer/common

edit:completion:arg-completer[ssh] = [@args]{
	common:completer [] [[_]{
		cat ~/.ssh/config | peach [line]{
			if (re:match "^Host " $line) {
				_ host = (re:split &max=2 'Host\s+' $line)
				put $host
			}
		}
	}] $@args
}

# vim: set fdm=marker sw=4 ts=4 ft=sh:
