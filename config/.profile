#start X
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && ( xinit 2>&1 | tee ~/.xlog )

