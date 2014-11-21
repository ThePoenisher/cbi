postfix_package:
  pkg.installed:
    - names:
      - postfix

postfix:
  service.running:
    - enable: True
    - require:
      - pkg: postfix
    - watch:
      - file: /etc/postfix/main.cf

{% set files = ['main.cf','sasl_passwd','aliases'] %}
{% for file in files %}
/etc/postfix/{{ file }}:
    file.managed:
    - template: jinja
    - source: salt://etc/postfix/{{ file }}
{% endfor %}

newaliases:
  cmd.wait:
    - watch:
        - file: /etc/postfix/aliases
  
postmap /etc/postfix/sasl_passwd:
  cmd.wait:
    - watch:
        - file: /etc/postfix/sasl_passwd