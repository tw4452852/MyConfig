# Update fonts cache
fc-cache -vf
# Load myself config
xrdb ~/.Xresources
# Update time every second in dwm toolbar
while true; do
	xsetroot -name "`date`"
	sleep 1
done &

# Start dwm in a loop
exec startdwm
