#state
base:
  '*':
    - zsh
    - main
    - gitolite.main
    - python
    - packages
{% if pillar['arch_desktop'] %}
    - ssh
    - X
    - apps
    - media
    - mail
{% endif %}