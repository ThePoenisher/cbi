#(echo "zlogin"; date; tty; echo "CBI: $CBI" ) >> /home/johannes/testlog 
if [[ $TERM != "dumb" ]]; then
				eval `keychain --eval -Q /home/johannes/.ssh/id_rsa`
				export PASSWORD_STORE_GIT=/home/data/personal
				export PASSWORD_STORE_DIR=$PASSWORD_STORE_GIT/password_store
		if [[ $TERM != "screen-"*  ]]; then
				if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
						startx -- vt7 &>> ~/.xlog &!
						vlock
						logout
				elif [[ $TERM != "linux" ]]; then
						exec tmux -2
				fi
		fi
fi
