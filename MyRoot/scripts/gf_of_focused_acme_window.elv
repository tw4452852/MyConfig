use str
use acme_tagline

var winid
if (has-env winid) {
  set winid = $E:winid
} else {
  set winid = (9 dial 'unix!'(9 namespace)/acmefocused)
}

acme_tagline:run $winid 'gf'