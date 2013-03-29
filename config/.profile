#start X

if [[ $TERM != "screen" ]]; then
		if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
				startx &>> ~/.xlog &!
				vlock
				logout
		else
				exec tmux new-session zsh
		fi
fi
