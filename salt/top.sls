#state
base:
  '*':
    - zsh
    - main
    - gitolite.main
    - python
    - packages
    - ssh
{% if pillar['arch_desktop'] %}
    - X11.main
    - X11.packages
    - apps
    - media
    - email
    - web
{% endif %}
{% if grains['cbi_machine'] == 'debussy' %}
    - tor
{% endif %}