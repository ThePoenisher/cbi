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
    - mail
{% endif %}