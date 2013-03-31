#pillar
base:
  '*':
    - common
{% if grains['cbi_machine'] == 'strauss' %}
    - strauss-gpg
{% elif grains['cbi_machine'] in ['scriabin','debussy'] %}
    - desktops-gpg
{% endif %}
