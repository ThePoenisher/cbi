{% for i in ['sshd_config','ssh_config'] %}
/etc/ssh/{{ i }}:
  file.managed:
    - template: jinja
    - source: salt://etc/{{ i }}
{% endfor %}

sshd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config


{% for usr in pillar['ssh_users_with_auth_keys'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.ssh/authorized_keys:
  file.managed:
    - template: jinja
    - source: salt://authorized_keys
    - user: {{ usr }}
    - group: {{ usr }}
    - require:
        - user: {{ usr }}
    - context:
        keys:
          - johannes@debussy
          - johannes@scriabin
{% endfor %}


