use re

-adb-options = [-s -p]
-adb-cmds = [put devices connect disconnect sync shell emu logcat forward help version wait-for-device start-server kill-server get-state get-serialno get-devpath status-window remount reboot reboot-bootloader root usb tcpip ppp reverse jdwp install uninstall bugreport backup restore disable-verity keygen push pull]

edit:completion:arg-completer[adb] = [@a]{

	n = (count $a)
	hasCmd = $false

	each [x]{ if (has-value $-adb-cmds $x) { hasCmd = $true ; break } } $a

	if (>= $n 2) {
		if (==s $a[-1] -) {
			put $@-adb-options
		} elif (or (==s $a[-2] -s) (==s $a[-2] disconnect)) {
			e:adb devices | eawk [@fields]{ if (or (==s $fields[1] List) (==s $fields[1] '')) { continue }; put $fields[1] }
		} elif (re:match /system/ $a[-2]) {
			re:find /system/ $a[-2] | each [x]{ put $a[-2][$x[start]:] }
		} elif (not $hasCmd) {
			put $@-adb-cmds
		} else {
			edit:complete-filename $@a
		}
	} else {
		edit:complete-filename $@a
	}
}

