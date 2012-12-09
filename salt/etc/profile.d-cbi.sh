# -*- mode: shell-script; -*-
CBI="{{ grains['cbi_home'] }}"
export CBI

CBI_MACHINE="{{ grains['cbi_machine'] }}"
export CBI_MACHINE


ALTERNATE_EDITOR=""
export ALTERNATE_EDITOR

PATH=$PATH:$CBI/bin
export PATH

#java and xmonad problems
#https://wiki.archlinux.org/index.php/Xmonad#Problems_with_Java_applications
export _JAVA_AWT_WM_NONREPARENTING=1

eval `keychain --eval -Q /home/johannes/.ssh/id_rsa /home/johannes/.ssh/github-kuerzn`
