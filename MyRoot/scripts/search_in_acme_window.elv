fn main {
  var winid
  if (has-env winid) {
    set winid = $E:winid
  } else {
    set winid = (9 dial 'unix!'(9 namespace)/acmefocused)
  }
  
  var line = (9p read acme/$winid/body | grep . -n | fzf +m | cut -d: -f1)
  if (!=s $line '') {
    print $line | 9p write acme/$winid/addr
    print 'dot=addr' | 9p write acme/$winid/ctl
    print 'show' | 9p write acme/$winid/ctl
  }
}

try { main } catch { nop }