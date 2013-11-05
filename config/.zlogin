#(echo "zlogin"; date; tty; echo "CBI: $CBI" ) >> /home/johannes/testlog 
if [[ $TERM != "dumb" ]]; then
				eval `keychain --eval -Q /home/johannes/.ssh/id_rsa`
		if [[ $TERM != "screen-"*  ]]; then
				if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
						startx &>> ~/.xlog &!
						vlock
						logout
				elif [[ $TERM != "linux" ]]; then
						exec tmux -2
				fi
		fi
fi
