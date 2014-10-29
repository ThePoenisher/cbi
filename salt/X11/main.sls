######   Templates  #########
{% set usr = pillar['desktop_user'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}

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
{% if grains['cbi_machine'] == 'kasse3og' %}
{% set prefix='kasse/' %}
{% set files = ['.xbindkeysrc.scm','.xinitrc' ] %}
{% else %}
{% set files = ['.xbindkeysrc.scm','.xinitrc'
                ,'.xmonad/xmonad.hs','.xmobarrc','.Xresources'] %}
{% set prefix='' %}
{% endif %}

{% for file in files %}
{{ home+'/'+file }}:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/'+prefix+file }}
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True
{% endfor %}

{% if grains['cbi_machine'] in [ 'debussy', 'scriabin' ] %}
########  gets overridden by xcreensaver settings app ####
{{ home }}/.xscreensaver:
  file.managed:
    - source: salt://X11/xscreensaver
    - user: {{ usr }}
    - group: {{ usr }}
    - force: True
{% endif %}
