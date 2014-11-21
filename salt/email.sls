mail_packages:
  pkg.installed:
    - names:
      - offlineimap
      - notmuch
      - notmuch-mutt
      - mutt
    - require:
        - pkg: perl-mime-tools


############  Offlineimap  is startet in xinitrc ########
# the systemd service has the problem, that tmux is startet without my
# env and I no not want login shells in every new tmux window
# 13-04-28

{% set usr = "johannes" %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.offlineimaprc:
  file.managed:
    - source: salt://offlineimaprc
    - template: jinja
    - user: {{ usr }}
    - group: {{ usr }}

{% set files = ['.mutt','.urlview','.mailcap','.notmuch-config'] %}
{% for file in files %}
{{ home }}/{{ file }}:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/{{ file }}
    - user: {{ usr }}
    - group: {{ usr }}
    - force: True
{% endfor %}