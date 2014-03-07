{% if pillar['arch_desktop'] %}
arch_web_packages:
  pkg.installed:
    - names:
      - lighttpd
      - php
      - php-cgi
      
{% set files = ['php/conf.d/cbi.ini'] %}
{% for file in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}
    - makedirs: True
    - template: jinja
{% endfor %}

lighttpd:
  service.running:
    - enable: True
    - require:
      - pkg: lighttpd
    - watch:
{% for file in files %}
      - file: /etc/{{ file }}
{% endfor %}


/etc/lighttpd/lighttpd.conf:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/lighttpd.conf
    - require:
      - pkg: lighttpd
    - force: True
    - makedirs: True
        
/srv/http/music:
  file.symlink:
    - target: /home/data/music

/srv/http/library:
  file.symlink:
    - target: /home/data/library


/srv/http/OneNote:
  file.symlink:
    - target: /home/data/archive/OneNote
      
  
# vsftpd:
#   service.running:
#     - enable: True
#     - require:
#       - pkg: vsftpd
      
{% endif %}