xmonad &!

xsetroot -cursor_name left_ptr

while true; do
		~/unibin/unicentaopos-3.70/start.sh
		if Xdialog --yesno "Computer herunterfahren?" 30 300; then
				exit 0;
		fi
done
