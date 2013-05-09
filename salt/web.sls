{% if pillar['arch_desktop'] %}
arch_web_packages:
  pkg.installed:
    - names:
      - lighttpd
  
lighttpd:
  service.running:
    - enable: True
    - require:
      - pkg: lighttpd


/etc/lighttpd/lighttpd.conf:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/lighttpd.conf
    - require:
      - pkg: lighttpd
    - force: True
    - makedirs: True
        
{% if grains['cbi_machine'] == 'scriabin' %}
/srv/http/music:
  file.symlink:
    - target: /home/data/music

/srv/http/library:
  file.symlink:
    - target: /home/data/library
{% else %}
/srv/http/music:
  file.symlink:
    - target: /home/data2/music

/srv/http/library:
  file.symlink:
    - target: /home/data2/library
{% endif %}


/srv/http/OneNote:
  file.symlink:
    - target: /home/data/archive/OneNote
      
  
# vsftpd:
#   service.running:
#     - enable: True
#     - require:
#       - pkg: vsftpd
      
{% endif %}