use path

var file = (9p read acme/index | awk '{print $6}'| fzf)

if (path:is-dir $file) {
  f -d $file
} else {
  B $file':1'
}