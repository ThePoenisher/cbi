mail_packages:
  pkg.installed:
    - names:
      - postfix
      - offlineimap
      - notmuch

postfix:
  service.running:
    - enable: True
    - require:
      - pkg: postfix
    - watch:
      - file: /etc/postfix/main.cf


{% set files = ['main.cf','sasl_passwd'] %}
{% for file in files %}
/etc/postfix/{{ file }}:
    file.managed:
    - template: jinja
    - source: salt://etc/postfix/{{ file }}
{% endfor %}
  
postmap /etc/postfix/sasl_passwd:
  cmd.wait:
    - watch:
        - file: /etc/postfix/sasl_passwd
      
{% set usr = "johannes" %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.offlineimaprc:
  file.managed:
    - source: salt://offlineimaprc
    - template: jinja
    - user: {{ usr }}
    - group: {{ usr }}
