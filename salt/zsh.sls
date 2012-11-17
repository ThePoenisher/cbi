#shebang jinja | yaml

git://github.com/robbyrussell/oh-my-zsh.git:
  git.latest:
    - rev: c2ae9e09ca1f33ff1e13e629a0b2e6bdd19f83a9
    - target: /usr/share/oh-my-zsh
    - force:


{% for usr in pillar['zsh_users'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.zshrc:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/zshrc
    - require:
        - user: {{ usr }}
{% endfor %}

      