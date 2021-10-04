# cache to tmp
export XDG_CACHE_HOME="/tmp/.cache"
# Update fonts cache
fc-cache -vf
# Load myself config
xrdb ~/.Xresources

eval "$(dbus-launch --sh-syntax --exit-with-session)"

# ibus
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
fcitx -r -d

# screenlocker
xautolock -locker 'xlock -mode blank' &

# start PulseAudio if it's not running
pulseaudio --start --exit-idle-time=-1

# rust
. ~/.cargo/env

# Go
. ~/.go/env

# Dart/Flutter
. ~/.dart/env

# Plan9Port
. ~/.p9p/env

# MySelf
export PATH=$PATH:$HOME/MyRoot/bin

# xbindkeys
pkill xbindkeys
xbindkeys -p

exec cwm 1>~/.twwm.log 2>&1
