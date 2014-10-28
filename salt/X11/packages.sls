{% if pillar['arch_desktop'] %}
arch_X11_packages:
  pkg.installed:
    - names:
      - xorg-server
      - xorg-xinit
      - terminator
      - xorg-server-utils
      - xterm
      - arandr
      - gnome-font-viewer
      - xorg-xclock
      - xorg-twm
      - xorg-utils
      - xcompmgr
      - xclip
      - xsel
      - xdiskusage
      - xdialog #for (my) xrename
      - transset-df
      - mesa-demos #glxgears
      - feh
      - eog
      - haskell-xmonad
      - haskell-xmonad-contrib
      - haskell-hostname
      - xmobar
      - xscreensaver
      - rxvt-unicode
      - xbindkeys
      - scrot
      - gksu
      - gconf-editor
# file opener: https://wiki.archlinux.org/index.php/Xdg-open      
      - xdg-utils
      - dmenu
      - dzen2
      - conky
      - qtcurve-kde3 #vor themes?
      - x11vnc
#gtk switcher
      - lxappearance
      - gtk-engines
      - pidgin
      - pidgin-otr
      - evince
      - tk #for gitk
      - thunar
      - tumbler #thumbnails in thunar
      - zathura-pdf-mupdf
      - zathura-ps
      - zathura-djvu
      - kdegraphics-gwenview
      - oxygen-icons
      - ffmpegthumbnailer #thumbnails in thunar
      - thunar-archive-plugin
      - pidgin-libnotify
      - sqliteman
      - sqlitebrowser
      - emacs #use emacs-nox for emacs without X11 support
# AUR:       - gtk-nova-theme
{% if grains['cbi_machine'] == 'scriabin' %}
      - xf86-video-intel      
      - xf86-input-synaptics

i915:
  kmod.present:
    - require:
      - pkg: xf86-video-intel
  
{% elif grains['cbi_machine'] == 'debussy' %}
      - xf86-video-ati
{% endif %}
{% endif %}

###### fonts #######
fonts:
  pkg.installed:
    - names:
        - ttf-bitstream-vera    
        - ttf-liberation
        - ttf-dejavu
        - ttf-droid
        - ttf-ubuntu-font-family
        - ttf-freefont
        - xorg-xfontsel
        - xorg-fonts-100dpi
        - xorg-fonts-75dpi
        - gtk2fontsel
        - terminus-font
#        - monaco  sehr hässlich, z.B. in Firefox
#        see also packer