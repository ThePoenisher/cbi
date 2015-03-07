#shebang jinja | yaml

zshgit:
  git.latest:
    - name: git://github.com/robbyrussell/oh-my-zsh.git
    - rev: c2ae9e09ca1f33ff1e13e629a0b2e6bdd19f83a9
    - target: /usr/share/oh-my-zsh
    - force:

#habe mal die neueste version getestet vom 
# 2014-10-28 7f07facf41e97d0de250f565d5e514f1e6c998a2
# 'cd' in order mit git war viel langsamer. würde oh-my-zsh lieber loswerden

#habe mal die neueste version getestet vom 
# 2015-02-25 e55c715
# jump to last dir '-' does not work anymore
# würde oh-my-zsh lieber loswerden
# workaround: GREP_OPTIONS in .zshrc losgeworden

/usr/share/oh-my-zsh/cache:
  file.directory:
    - require:
      - git: zshgit
    - mode: 777

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

      
