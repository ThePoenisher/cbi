#start X
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx &>> ~/.xlog &!
  vlock
  logout
fi

