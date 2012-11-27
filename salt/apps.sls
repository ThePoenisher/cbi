{% if pillar['arch_desktop'] %}
arch_browser_packages:
  pkg.installed:
    - names:
      - firefox
      - flashplugin
      - thunderbird
      - chromium
      - gnome-terminal
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

{{ home }}/.gconf:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/.gconf
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - force: True
    - makedirs: True