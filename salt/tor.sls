tor_packages:
  pkg.installed:
    - names:
      - bridge-utils
      - tor
      
{% for p in
 ['arm'] %}
packer --noconfirm --noedit  -S {{ p }}:
  cmd.run:
    - unless: pacman -Q {{ p }}
{% endfor %}
  
{% set files =
[
('torsocks.conf','')
] %}
{% for file,ending in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}{{ ending }}
    - makedirs: True
    - template: jinja
{% endfor %}

#services

{% set services =
[('netctl@',true,['tor_bridge'],['netctl/tor_bridge'])
,('tor',false,[''],['tor/torrc'])
]%}
{% for service, start, instances, confs in services %}
{% for conf in confs %}
/etc/{{ conf }}:
  file.managed:
    - source: salt://etc/{{ conf }}
    - makedirs: True
    - template: jinja
{% endfor %}
      
{% for instance in instances %}
{{ service~instance }}:
  service:
{% if start %}
    - running
    - enable: True
{% else %}
    - disabled
{% endif %}
    - watch:
{% for conf in confs %}
      - file: /etc/{{ conf }}
{% endfor %}
{% endfor %}
{% endfor %}