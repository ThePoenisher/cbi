mail_packages:
  pkg.installed:
    - names:
      - postfix
      - offlineimap
      - notmuch
      - notmuch-mutt
    - require:
        - pkg: perl-mime-tools


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

{% set files = ['.mutt','.urlview'] %}
{% for file in files %}
{{ home }}/{{ file }}:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/{{ file }}
    - user: {{ usr }}
    - group: {{ usr }}
    - force: True
{% endfor %}