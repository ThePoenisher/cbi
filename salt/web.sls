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
        
/srv/http/music:
  file.symlink:
    - target: /home/data2/music

/srv/http/library:
  file.symlink:
    - target: /home/data2/library


/srv/http/OneNote:
  file.symlink:
    - target: /home/data/archive/OneNote
      
{% endif %}