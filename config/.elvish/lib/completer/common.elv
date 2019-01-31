use re

fn completer [handles @args]{
	opts = []

	man $args[0] | peach [x]{ re:find '^\s*-(-?\w[\w-]*)\s*,?\s*(?:-(-?\w[\w-]*))?' $x } |
	peach [x]{
		m = [&]
		peach [g]{
			if (has-prefix $g[text] -) {
				m[long] = $g[text][1:]
			} elif (== (count $g[text]) 1) {
				m[short] = $g[text]
			}
		} $x[groups][1:]
		if (not (eq $m [&])) {
			opts = [$@opts $m]
		}
	}

	edit:complete-getopt $args[1:] $opts $handles
}

edit:completion:arg-completer[''] = [@args]{ completer [[_]{ edit:complete-filename $@args } ...] $@args }

# vim: set fdm=marker sw=4 ts=4 ft=sh:
