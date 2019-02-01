use github.com/zzamboni/elvish-completions/comp

fn -gen-adb-devices {
	e:adb devices | eawk [@fields]{ if (or (==s $fields[1] List) (==s $fields[1] '')) { continue }; put $fields[1] }
}

-adb-opts = [
[ &short= s
  &arg-required= $true
  &arg-completer= $-gen-adb-devices~
]]

-adb-cmds = [put devices connect disconnect sync shell emu logcat forward help version wait-for-device start-server kill-server get-state get-serialno get-devpath status-window remount reboot reboot-bootloader root usb tcpip ppp reverse jdwp install uninstall bugreport backup restore disable-verity keygen push pull]

edit:completion:arg-completer[adb] = (comp:sequence [$-adb-cmds $comp:files~ ...] &opts=$-adb-opts)

# vim: set fdm=marker sw=4 ts=4 ft=sh:
