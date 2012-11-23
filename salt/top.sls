#state
base:
  '*':
    - zsh
    - main
    - gitolite.main
    - python
{% if pillar['arch_desktop'] %}
    - X
    - browsers
    - media
    - mail
{% endif %}