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
    - X
    - apps
    - media
    - mail
{% endif %}