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
      - mesa-demos
      - xmonad
      - xmonad-contrib
      - xmobar
# file opener: https://wiki.archlinux.org/index.php/Xdg-open      
      - xdg-utils
      - dmenu
      - gmrun
      - firefox
{% if grains['cbi_machine'] == 'scriabin' %}
      - xf86-video-intel      
      - xf86-input-synaptics

i915:
  kmod.present:
    - require:
      - pkg: xf86-video-intel
  
{% endif %}
{% endif %}


{% set usr = pillar['desktop_user'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.xinitrc:
  file.managed:
    - source: salt://X11/xinitrc
    - require:
        - user: {{ usr }}
    - force: True

{% set files = ['.xmonad/xmonad.hs','.xmobarrc' ] %}
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