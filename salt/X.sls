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
      - xorg-xdpyinfo
      - xorg-xev
      - xcompmgr
      - transset-df
      - mesa-demos #glxgears
      - feh
      - xmonad
      - xmonad-contrib
      - xmobar
      - xscreensaver
      - rxvt-unicode
# file opener: https://wiki.archlinux.org/index.php/Xdg-open      
      - xdg-utils
      - dmenu
      - gmrun
      - dzen2
      - conky
      - ttf-bitstream-vera
      - thunderbird
#gtk switcher
      - lxappearance
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

######   Other stuff  #######
export DISPLAY=:0;  feh --bg-fill "$(find -L {{ grains['cbi_home'] }}/desktop-artwork/wallpapers/ |shuf -n1)":
  cron.present:
    - user: johannes
      
######   Templates  #########
{% set usr = pillar['desktop_user'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.xinitrc:
  file.managed:
    - source: salt://X11/xinitrc
    - require:
        - user: {{ usr }}
    - force: True
      
######  Symlinked Files  #########
{% set files = ['.xmonad/xmonad.hs','.xmobarrc','.Xresources','.conky_bar' ] %}
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
