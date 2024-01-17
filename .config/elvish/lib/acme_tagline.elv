use str

fn run {|winid cmd|
  echo nomenu | 9p write acme/$winid/ctl
  defer { echo menu | 9p write acme/$winid/ctl }

  var tagline = (9p read acme/$winid/tag | slurp)
  var start = (str:index $tagline '|')
  if (== $start -1) {
    return
  }
  set start = (+ $start 1)
  var origin = $tagline[$start..]
  defer {
    echo cleartag | 9p write acme/$winid/ctl
    print $origin | 9p write acme/$winid/tag
  }

  echo cleartag | 9p write acme/$winid/ctl
  echo $cmd | 9p write acme/$winid/tag
  echo Mx$start" "(+ $start (count $cmd)) | 9p write acme/$winid/event
}