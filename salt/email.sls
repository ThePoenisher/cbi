mail_packages:
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


{% set files = ['main.cf','sasl_passwd'] %}
{% for file in files %}
/etc/postfix/{{ file }}:
    file.managed:
    - template: jinja
    - source: salt://etc/postfix/{{ file }}
{% endfor %}
      
postmapsasl:
  cmd.wait:
    - name: postmap /etc/postfix/sasl_passwd
    - watch:
        - file: /etc/postfix/sasl_passwd
      