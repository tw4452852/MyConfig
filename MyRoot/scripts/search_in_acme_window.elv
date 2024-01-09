use str

var winid
if (has-env winid) {
  set winid = $E:winid
} else {
  set winid = (9 dial 'unix!'(9 namespace)/acmefocused)
}

var line = (9p read acme/$winid/body | grep . -n | fzf +m | cut -d: -f1)
if (==s $line '') {
  exit
}

{
  echo nomenu | 9p write acme/$winid/ctl
  defer { echo menu | 9p write acme/$winid/ctl }

  var tagline = (9p read acme/$winid/tag | slurp)
  var start = (str:index $tagline '|')
  if (== $start -1) {
    exit
  }
  set start = (+ $start 1)
  var origin = $tagline[$start..]
  defer {
    echo cleartag | 9p write acme/$winid/ctl
    print $origin | 9p write acme/$winid/tag
  }

  # append `:<line>` to the tagline
  var cmd = ':'$line
  echo cleartag | 9p write acme/$winid/ctl
  echo $cmd | 9p write acme/$winid/tag
  echo Ml$start" "(+ $start (count $cmd)) | 9p write acme/$winid/event
}