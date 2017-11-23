use re

edit:arg-completer[ssh] = [@cmd]{
	cat ~/.ssh/config | each [line]{
		if (re:match "^Host " $line) {
			_ host = (re:split &max=2 'Host\s+' $line)
			put $host
		}
	}
}
