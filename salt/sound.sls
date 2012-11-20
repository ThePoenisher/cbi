sound_packages:
{% if pillar['arch_desktop'] %}
  pkg.installed:
    - names:
      - alsa-utils
      - pulseaudio
      - pulseaudio-alsa
      #GUI
      - pavucontrol
{% if grains['cbi_machine'] == 'scriabin' %}
{% endif %}
{% endif %}


# {% set usr = pillar['desktop_user'] %}
# {% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
# {{ home }}/.xinitrc:
#   file.managed:
#     - source: salt://X11/xinitrc
#     - require:
#         - user: {{ usr }}
#     - force: True

# {% set files = ['.xmonad/xmonad.hs','.xmobarrc','.Xdefaults','.conky_bar' ] %}
# {% for file in files %}
# {{ home+'/'+file }}:
#   file.symlink:
#     - target: {{ grains['cbi_home']+'/config/'+file }}
#     - user: {{ usr }}
#     - group: {{ usr }}
#     - require:
#         - user: {{ usr }}
#     - force: True
#     - makedirs: True
# {% endfor %}