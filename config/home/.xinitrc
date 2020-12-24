# cache to tmp
export XDG_CACHE_HOME="/tmp/.cache"
# Update fonts cache
fc-cache -vf
# Load myself config
xrdb ~/.Xresources

eval "$(dbus-launch --sh-syntax --exit-with-session)"

# ibus
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx5"
export QT_IM_MODULE="fcitx5"
fcitx5 -r -d

# screenlocker
xautolock -locker 'xlock -mode blank' &

# start PulseAudio if it's not running
pulseaudio --start --exit-idle-time=-1

exec cwm 1>~/.twwm.log 2>&1
