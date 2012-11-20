#shebang jinja | yaml

git://github.com/robbyrussell/oh-my-zsh.git:
  git.latest:
    - rev: c2ae9e09ca1f33ff1e13e629a0b2e6bdd19f83a9
    - target: /usr/share/oh-my-zsh
    - force:

{% if grains['os'] == 'Arch' %}
grml-zsh-config:
  pkg.installed
{% else %}
zsh:
  pkg.installed

/etc/zsh/zshrc:
  file.managed:
    - source: http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
    - require:
      - pkg: zsh
    - source_hash: sha1=0628afb861c19d122d66ff602752156cf8eef7c9
{% endif %}

  

{% for usr in pillar['zsh_users'] %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{{ home }}/.zshrc:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/.zshrc
    - require:
        - user: {{ usr }}
    - force: True
{% endfor %}

      