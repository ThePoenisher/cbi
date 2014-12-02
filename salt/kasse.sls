/root/.zlogin:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/kasse/zlogin_root
    - user: root
    - makedirs: true
    - force: True

/home/kasse/.zlogin:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/kasse/zlogin_kasse
    - user: kasse
    - makedirs: true
    - force: True
      
mysqld:
  service.running:
    - enable: true
    - require:
      - pkg: mariadb

kasse_pkgs:
  pkg.installed:
    - names:
      - mariadb
      - setserial
      
dhcp1:
  service.dead:
    - name: dhcpcd@{{ pillar['eth0'] }}
dhcp2:
  service.disabled:
    - name: dhcpcd@{{ pillar['eth0'] }}


kasse:
  user.present:
    - groups:
      - cbi
      - uucp #for serial ttyS*
    - shell: /bin/zsh



{% set services =
[
('getty@'           ,true ,['tty1']    ,['systemd/system/getty@tty1.service.d/autologin.conf'])
,('netctl-ifplugd@'       ,true ,['enp2s8']    ,['netctl/eth0_kassen_innkaufhaus'])
]%}
{% for service, start, instances, confs in services %}
{% for conf in confs %}
/etc/{{ conf }}:
  file.managed:
    - template: jinja
    - source: salt://etc/{{ conf }}
{% endfor %}
      
{% for instance in instances %}

# these service are to delicate to be restartet in this remotely accessed box
{{ service~instance }}:
  service:
{% if start %}
    - running
    - enable: True
{% else %}
    - disabled
{% endif %}
#     - watch:
#       - cmd: systemd-reload-{{service~instance}}
# {% for conf in confs %}
#       - file: /etc/{{ conf }}
{% endfor %}

        
systemd-reload-{{service~instance}}:
  cmd.wait:
    - name: systemctl --system daemon-reload
    - watch:
{% for conf in confs %}
      - file: /etc/{{ conf }}
{% endfor %} 
{% endfor %} #instance

{% endfor %} #service


