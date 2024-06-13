use path

var file = (9p read acme/index | awk '{print $6}'| fzf)

if (path:is-dir $file) {
  f $file
} else {
  B $file
}