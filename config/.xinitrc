#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/* ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

############  my stuff

#using ALTERNATE_EDITOR="" instead:
#pgrep -a -f 'emacs --daemon' || emacs --daemon &!

xset -b #disable PC beep
xset r rate 200  45

# solve the problem with ZEROS 0000000
xinput --disable "saa7134 IR (Terratec Cinergy 40"

#if [ -f ~/.fehbg ]; then source ~/.fehbg; fi
feh_bg BG &

setxkbmap -layout de -option ctrl:nocaps
setxkbmap -layout "us" -variant altgr-intl
a=52;b=29;c=xmodmap;d="$c -e '";$c -pke | sed -nr "s/^(keycode *)$b(.*)/$d\1$a\2'/p;t;s/^(keycode *)$a(.*)/$d\1$b\2'/p" | sh

xsetroot -cursor_name left_ptr

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 6 --transparent true --alpha 0 --tint 0x000000 --height 16 &

systemd-cat devmon --info-on-mount &
xscreensaver &

maildir_watch &

TMUX= /usr/bin/tmux -2 new-session -ds OfflineIMAP "/usr/bin/offlineimap" >> .xlog_offlineimap

#xmobar &
xbindkeys


#xcompmgr & (macht die borders von xmonad irgendwie auf nervige weise durchsichtig)
exec xmonad

