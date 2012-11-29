{% if pillar['arch_desktop'] %}
arch_X11_packages:
  pkg.installed:
    - names:
      - xorg-server
      - xorg-xinit
      - xorg-server-utils
      - xterm
      - xorg-xclock
      - xorg-twm
      - xorg-utils
      - xcompmgr
      - xclip
      - xpdf
      - transset-df
      - mesa-demos #glxgears
      - feh
      - xmonad
      - xmonad-contrib
      - xmobar
      - xscreensaver
      - rxvt-unicode
      - xbindkeys
# file opener: https://wiki.archlinux.org/index.php/Xdg-open      
      - xdg-utils
      - dmenu
      - gmrun
      - dzen2
      - conky
      - qtcurve-kde3 #vor themes?
#gtk switcher
      - lxappearance
      - gtk-engines
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

      
######   Templates  #########
{% set usr = pillar['desktop_user'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.xinitrc:
  file.managed:
    - source: salt://X11/xinitrc
    - require:
        - user: {{ usr }}
    - force: True
    - user: {{ usr }}
    - group: {{ usr }}

#autostart:
x11Autostart:
  file.symlink:
    - names: 
      - {{ home }}/.profile
      - {{ home }}/.zlogin
    - target: {{ grains['cbi_home'] }}/config/.profile
    - user: {{ usr }}
    - group: {{ usr }}
      
{% if grains['cbi_machine'] == 'debussy' %}
/etc/X11/xorg.conf.d/20-radoen.conf:
  #file.managed:
  file.absent:
    - source: salt://X11/radeon.conf
{% endif %}

# activates terminus font
/etc/X11/xorg.conf:
  file.managed:
    - source: salt://X11/xorg.conf

######  Symlinked Files  #########
{% set files = ['.xmonad/xmonad.hs','.xmobarrc','.Xresources','.xbindkeysrc.scm' ] %}
{% for file in files %}
{{ home+'/'+file }}:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/'+file }}
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True
{% endfor %}


########### fonts #############
fonts:
  pkg.installed:
    - names:
        - ttf-bitstream-vera    
        - ttf-liberation
        - ttf-dejavu
        - ttf-droid
        - ttf-ubuntu-font-family
        - xorg-xfontsel
        - gtk2fontsel
        - terminus-font
#        - ttf-ms-fonts (aur)
#        - monaco  sehr hässlich, z.B. in Firefox

/etc/fonts/conf.d/70-yes-bitmaps.conf:
  file.symlink:
    - target: /etc/fonts/conf.avail/70-yes-bitmaps.conf
    - force: True
