#state
base:
  '*':
    - zsh
    - common
    - ssh
    - packages
{% if grains['cbi_machine'] == 'kasse3og' %}
    - kasse
{% else %}
    - main
    - gitolite.main
    - python
{% if pillar['arch_desktop'] %}
    - X11.main
    - X11.packages
    - apps
    - media
    - email
    - web
{% endif %}
{% if pillar['arch_desktop'] %}
    - tor
{% endif %}
{% endif %}