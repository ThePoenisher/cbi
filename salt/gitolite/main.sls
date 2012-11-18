{% if pillar['gitolite'] is defined %}

{% set usr=pillar['gitolite']['user'] %}
{% set dir=pillar['gitolite']['dir'] %}
{% set authorized_keys = pillar['gitolite']['authorized_keys'] %}
{% set conf_file=pillar['gitolite']['conf_file'] %}
{% set bin=dir+"/bin" %}
{% set dotgit=dir+"/.gitolite" %}


{{ usr }}:
  user.present:
    - home: {{ dir }}

{{ bin }}:
  file.directory:
    - user: {{ usr }}
    - group: {{ usr }}
    - makedirs: True
    - require:
      - user: {{ usr }}

repo:        
  git.latest:
    - name: git://github.com/sitaramc/gitolite
    - rev: d491b5384f572d5a4bedb12aac430dc770ea475f
    # If you change revision, please check: updateconf and sshkeys
    - target: {{ dir }}/gitolite
    - runas: {{ usr }}
    - force:
    - require:
      - file: {{ bin }}

install: 
  cmd.run:
    - name: {{ dir }}/gitolite/install -ln {{ dir }}/bin
    - unless: test -x {{ bin }}/gitolite
    - user: {{ usr }}
    - require:
      - git: repo

setup:
  cmd.run:
    - name: su -c '{{bin}}/gitolite setup -a NO_ADMIN_USER_THERE_IS_NO_ADMIN_USER' {{usr}}
    - unless: test -f {{ dotgit }}.rc
    - require:
      - cmd: install

gitoliteconf:
  file.managed:
    - name: {{ dotgit }}/conf/gitolite.conf
    - user: {{ usr }}
    - group: {{ usr }}
    - source: salt://{{ conf_file }}
    - require:
      - cmd: setup

# -  this replicated the post update hook from:
#  gitolite/src/lib/Gitolite/Hooks/PostUpdate.pm::sub post_update
updateconf:
  cmd.wait:
    - name: su -c '{{ bin }}/gitolite compile; {{bin}}/gitolite trigger POST_COMPILE' {{ usr }}
    - watch:
      - file: gitoliteconf

# this should replicate:
# gitolite/src/triggers/post-compile/ssh-authkeys
sshkeys:
  file.managed:
    - name: {{ dir }}/.ssh/authorized_keys
    - template: jinja
    - makedirs: True
    - context:
       gitolite_shell:  {{ dir }}/gitolite/src/gitolite-shell
    - source: salt://{{ authorized_keys }}
        

{% endif %}