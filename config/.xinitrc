# cache to tmp
export XDG_CACHE_HOME="/tmp/.cache"
# Update fonts cache
fc-cache -vf
# Load myself config
xrdb ~/.Xresources

# ibus
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
fcitx -r

exec twwm 1>~/.twwm.log 2>&1
