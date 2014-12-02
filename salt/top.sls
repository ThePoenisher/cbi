#state
base:
  '*':
    - zsh
    - common
    - ssh
    - packages
{% if grains['cbi_machine'] == 'kasse3og' %}
    - kasse
    - X11.fonts
    - X11.main
    - X11.packages
    - postfix
{% else %}
    - main
    - gitolite.main
    - python
{% if pillar['arch_desktop'] %}
    - X11.main
    - X11.packages
    - X11.fonts
    - apps
    - media
    - email
    - web
    - postfix
{% endif %}
{% if pillar['arch_desktop'] %}
    - tor
{% endif %}
{% endif %}