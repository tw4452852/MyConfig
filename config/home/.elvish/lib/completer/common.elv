use github.com/zzamboni/elvish-completions/comp

fn get-opts [@cmd]{
_ = ?((external $cmd[0]) --help 2>&1) | comp:extract-opts
}

edit:completion:arg-completer[''] = (comp:sequence [ $comp:files~ ... ] &opts=$get-opts~)

# vim: set fdm=marker sw=4 ts=4 ft=sh:
