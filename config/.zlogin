if [[ $TERM != "dumb" ]]; then
		eval `keychain --eval -Q /home/johannes/.ssh/id_rsa /home/johannes/.ssh/github-kuerzn`
		if [[ $TERM != "screen"  ]]; then
				if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
						#start X
						startx &>> ~/.xlog &!
						vlock
						logout
				else
						exec tmux new-session zsh
				fi
		fi
fi
