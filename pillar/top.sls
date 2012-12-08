#pillar
base:
  '*':
    - common
{% if grains['cbi_machine'] == 'strauss' %}
    - strauss-gpg
{% endif %}