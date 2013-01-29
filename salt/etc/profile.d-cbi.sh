# -*- mode: shell-script; -*-
CBI="{{ grains['cbi_home'] }}"
export CBI

CBI_MACHINE="{{ grains['cbi_machine'] }}"
export CBI_MACHINE

EDITOR="my_emacs -c -nw"
export EDITOR

ALTERNATE_EDITOR=""
export ALTERNATE_EDITOR

PATH=$PATH:$CBI/bin
export PATH

#java and xmonad problems
#https://wiki.archlinux.org/index.php/Xmonad#Problems_with_Java_applications
export _JAVA_AWT_WM_NONREPARENTING=1
#https://wiki.archlinux.org/index.php/Java_Runtime_Environment_Fonts
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
export JAVA_FONTS=/usr/share/fonts/TTF

eval `keychain --eval -Q /home/johannes/.ssh/id_rsa /home/johannes/.ssh/github-kuerzn`
