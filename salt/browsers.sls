{% if pillar['arch_desktop'] %}
arch_browser_packages:
  pkg.installed:
    - names:
      - firefox
      - flashplugin
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