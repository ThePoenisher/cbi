{% if pillar['arch_desktop'] %}
arch_browser_packages:
  pkg.installed:
    - names:
      - firefox
      - flashplugin
      - thunderbird
      - chromium
{% endif %}

{% set usr = pillar['desktop_user'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.pentadactylrc:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/.pentadactylrc
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True

{{ home }}/.pentadactyl/plugins:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/pentadactyl-plugins
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True


{{ home }}/.thunderbird/profiles.ini:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/thunderbird_profiles.ini
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True

{{ home }}/.mozilla/firefox/profiles.ini:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/firefox_profiles.ini
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True
      
# gconfshut:
#   cmd.wait:
#     - name: killall -9 gconfd-2
#     #- name: gconftool-2 --shutdown
#     - watch:
#       - file: gnome-terminal.conf
#     - user: {{ usr }}

        
{{ home }}/.config/terminator/config:
  file.managed:
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - template: jinja
    - source: salt://terminator
    - makedirs: True

{{ home }}/.gtkrc-2.0.mine:
  file.managed:
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - template: jinja
    - source: salt://gtkrc-2.0.mine

      
{% for f in
[".config/gtk-2.0"
,".config/gtk-3.0"
,".config/ranger/rifle.conf"
,'.config/dconf'
,'.mplayer'
,'.mpv' ] %}
{{ home }}/{{ f }}:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/{{ f }}
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True
{% endfor %}

{{ home }}/.local/share/applications:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/applications
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True
