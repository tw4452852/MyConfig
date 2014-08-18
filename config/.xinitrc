# Update fonts cache
fc-cache -vf
# Load myself config
xrdb ~/.Xresources
# Update time every second in dwm toolbar
while true; do
	xsetroot -name "`date`"
	sleep 1
done &

# ibus
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
fcitx &

# Start dwm in a loop
exec startdwm
