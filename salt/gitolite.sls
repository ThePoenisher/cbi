{% if pillar['gitolite'] is defined %}

{% set usr=pillar['gitolite']['user'] %}
{% set dir=pillar['gitolite']['dir'] %}
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

{{ dotgit }}/conf/gitolite.conf:
  file.managed:
    - user: {{ usr }}
    - group: {{ usr }}
    - source: salt://{{ conf_file }}
    - require:
      - cmd: setup


{% endif %}