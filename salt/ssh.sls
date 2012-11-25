/etc/ssh/sshd_config:
  file.managed:
    - template: jinja
    - source: salt://etc/sshd_config

sshd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config


{% for u in pillar['ssh_users_with_auth_keys'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(u))  %}
{{ home }}/.ssh/authorized_keys:
  file.managed:
    - template: jinja
    - source: salt://authorized_keys
    - context:
        keys:
          - johannes@debussy
          - johannes@scriabin
{% endfor %}


