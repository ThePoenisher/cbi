# -*- mode: shell-script; -*-
source /etc/zsh/zshenv
# scheiße: brauche ich, weil xmonad bash aufruft und deshalb der path dann fehlt,
# mit toller fehler meldung: "Unable to find a shell" bei befehl: terminator -x sasdfhksjfh

{% if grains['cbi_machine'] in ['scriabin','debussy','kasse3og'] %}

#java and xmonad problems
#https://wiki.archlinux.org/index.php/Xmonad#Problems_with_Java_applications
export _JAVA_AWT_WM_NONREPARENTING=1
#https://wiki.archlinux.org/index.php/Java_Runtime_Environment_Fonts
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
export JAVA_FONTS=/usr/share/fonts/TTF

{% endif %}


export LESS=-Ri
