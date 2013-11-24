tor_packages:
  pkg.installed:
    - names:
      - bridge-utils
      - tor
  
{% set files =
[
] %}
{% for file in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}
    - makedirs: True
    - template: jinja
{% endfor %}

#services

{% set services =
[('netctl@',['tor_bridge'],['netctl/tor_bridge'])
,('tor',[''],['tor/torrc'])
]%}
{% for service, instances, confs in services %}
{% for conf in confs %}
/etc/{{ conf }}:
  file.managed:
    - source: salt://etc/{{ conf }}
    - makedirs: True
    - template: jinja
{% endfor %}
      
{% for instance in instances %}
{{ service~instance }}:
  service.running:
    - enable: True
    - watch:
{% for conf in confs %}
      - file: /etc/{{ conf }}
{% endfor %}
{% endfor %}
{% endfor %}