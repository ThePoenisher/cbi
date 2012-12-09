#!/bin/sh
# adapted from https://wiki.archlinux.org/index.php/Pm-utils#Locking_the_screen_saver_on_hibernate_or_suspend
# 00screensaver-lock: lock workstation on hibernate or suspend

if [ "$1" = "pre" ]; then


		DBUS=$(ps aux | grep 'dbus-launch' | grep -v root)
		if [[ ! -z $DBUS ]];then
				USER=$(echo $DBUS | awk '{print $1}')
				USERHOME=$(getent passwd $USER | cut -d: -f6)
				export XAUTHORITY="$USERHOME/.Xauthority"
				for x in /tmp/.X11-unix/*; do
						DISPLAYNUM=$(echo $x | sed s#/tmp/.X11-unix/X##)
						if [[ -f "$XAUTHORITY" ]]; then
								export DISPLAY=":$DISPLAYNUM"
						fi
				done
		else
				USER=johannes
				USERHOME=/home/johannes
				export XAUTHORITY="$USERHOME/.Xauthority"
				export DISPLAY=":0"
		fi

		# does not work (not locking, or hangups, ...)
		# su $USER -c "xlock" &
		exec su $USER -c "xscreensaver-command -lock"
		
fi
