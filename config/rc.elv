# key bindings
edit:insert:binding[c-a] = edit:move-dot-sol
edit:insert:binding[c-e] = edit:move-dot-eol
edit:insert:binding[c-w] = edit:kill-word-left
edit:insert:binding[a-w] = edit:kill-small-word-left
edit:insert:binding[a-p] = edit:history:start
edit:history:binding[a-p] = edit:history:up
edit:history:binding[a-n] = edit:history:down-or-quit

# abbreviates
edit:abbr['~A'] = ~/code/android/5.1/out/target/product/x86_64/

# completion
edit:-matcher[''] = { edit:match-prefix &smart-case=$true $@ }

use re
edit:arg-completer[adb] = {
	os = [-s -p]
	cs = [put devices connect disconnect sync shell emu logcat forward help version wait-for-device start-server kill-server get-state get-serialno get-devpath status-window remount reboot reboot-bootloader root usb tcpip ppp reverse jdwp install uninstall bugreport backup restore disable-verity keygen push pull]

	a = [$@]
	n = (count $a)
	hasCmd = $false

	each [x]{ if (has-value $cs $x) { hasCmd = $true ; break } } $a

	if (>= $n 2) {
		if (==s $a[-1] -) {
			put $@os
		} elif (or (==s $a[-2] -s) (==s $a[-2] disconnect)) {
			e:adb devices | eawk { if (or (==s $1 List) (==s $1 '')) { continue }; put $1 }
		} elif (re:match /system/ $a[-2]) {
			re:find /system/ $a[-2] | each [x]{ put $a[-2][$x[start]:] }
		} elif (not $hasCmd) {
			put $@cs
		} else {
			edit:complete-filename $@a
		}
	} else {
		edit:complete-filename $@a
	}
}
