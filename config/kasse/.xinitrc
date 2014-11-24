xmonad &!

numlockx

xsetroot -cursor_name left_ptr

while true; do
		~/unicenta/dist/start.sh > /dev/null
		if [ "$?" -eq 7 ] || Xdialog --yesno "Computer herunterfahren?" 30 300; then
				exit 0;
		fi
done
