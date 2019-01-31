use re

fn completer [opts handles @args]{
	if (eq $opts []) {
		man $args[0] | peach [x]{ re:find '^\s{0,10}-(-?\w[\w-]*)\s*,?\s*(?:-(-?\w[\w-]*))?' $x } |
		peach [x]{
			m = [&]
			peach [g]{
				if (has-prefix $g[text] -) {
					m[long] = $g[text][1:]
				} elif (!=s $g[text] '') {
					m[short] = $g[text]
				}
			} $x[groups][1:]
			opts = [$@opts $m]
		}
	}

	edit:complete-getopt $args[1:] $opts $handles
}

edit:completion:arg-completer[''] = [@args]{ completer [] [[_]{ edit:complete-filename $@args } ...] $@args }

# vim: set fdm=marker sw=4 ts=4 ft=sh:
