#state
base:
  '*':
    - zsh
    - main
    - gitolite.main
    - python
    - ssh
{% if pillar['arch_desktop'] %}
    - X
    - browsers
    - media
    - mail
{% endif %}