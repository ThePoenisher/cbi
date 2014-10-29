arch_X11_packages:
  pkg.installed:
    - names:
      - xorg-server
      - xorg-xinit
      - xorg-server-utils
      - xterm
      - arandr
      - xorg-xclock
      - xorg-twm
      - xorg-utils
      - xclip
      - xsel
      - xdiskusage
      - xdialog #for (my) xrename
      - eog
      - xbindkeys
      - scrot
      - xdg-utils
      - x11vnc
      - lxappearance
      - gtk-engines
      - evince
      - tk #for gitk
      - sqliteman
      - sqlitebrowser
{% if grains['cbi_machine'] == 'kasse3og' %}
      - xf86-video-chips
      - mesa-libgl
{% endif %}
{% if grains['cbi_machine'] in [ 'debussy', 'scriabin' ] %}
      - terminator
      - gnome-font-viewer
      - xcompmgr
      - transset-df
      - mesa-demos #glxgears
      - feh
      - haskell-xmonad
      - haskell-xmonad-contrib
      - haskell-hostname
      - xmobar
      - xscreensaver
      - rxvt-unicode
      - gksu
      - gconf-editor
# file opener: https://wiki.archlinux.org/index.php/Xdg-open      
      - dmenu
      - dzen2
      - conky
      - qtcurve-kde3 #vor themes?
#gtk switcher
      - pidgin
      - pidgin-otr
      - thunar
      - thunar-archive-plugin
      - tumbler #thumbnails in thunar
      - zathura-pdf-mupdf
      - zathura-ps
      - zathura-djvu
      - kdegraphics-gwenview
      - oxygen-icons
      - ffmpegthumbnailer #thumbnails in thunar
      - pidgin-libnotify
      - emacs #use emacs-nox for emacs without X11 support
# AUR:       - gtk-nova-theme
{% if grains['cbi_machine'] == 'scriabin' %}
      - xf86-video-intel      
      - xf86-input-synaptics

# not needed? also this recipe is not persistent
# i915:
#   kmod.present:
#     - require:
#       - pkg: xf86-video-intel
  
{% elif grains['cbi_machine'] == 'debussy' %}
      - xf86-video-ati
{% endif %}
{% endif %}
