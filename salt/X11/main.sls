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

#autostart is done in .zlogin:
      
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
    - template: jinja

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

########  gets overridden by xcreensaver settings app ####
{{ home }}/.xscreensaver:
  file.managed:
    - source: salt://X11/xscreensaver
    - user: {{ usr }}
    - group: {{ usr }}
    - force: True

########### fonts #############

fc-cache:
  cmd.wait:
    - watch:
      - file: yesb
      - file: nob
      - file: fconf
        
yesb:
  file.symlink:
    - name:  /etc/fonts/conf.d/70-yes-bitmaps.conf
    - target: /etc/fonts/conf.avail/70-yes-bitmaps.conf
    - force: True
      
nob:
  file.absent:
    - name: /etc/fonts/conf.d/70-no-bitmaps.conf
      
packer --noconfirm --noedit  -S ttf-ms-fonts:
  cmd.run:
    - unless: pacman -Q ttf-ms-fonts


fconf:
  file.managed:
    - source: salt://etc/fonts_local.conf
    - name: /etc/fonts/local.conf
    - template: jinja
      
