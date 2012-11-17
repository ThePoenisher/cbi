#!jinja | yaml



git://github.com/robbyrussell/oh-my-zsh.git:
  git.latest:
    - rev: c2ae9e09ca1f33ff1e13e629a0b2e6bdd19f83a9
    - target: /usr/share/oh-my-zsh
    - force:


        
        
test.echo:
  module.run:    
    - text: testings
wow123:
  module.run:
    - name: test.echo
    - text: {{ salt['network.ip_addrs']() }}

      
{% set testing = 'it worked' %}
/tmp/asd123:
  file.managed:
    - source: salt://asd
    - context:
        testing2:  {{ testing }}
    - template: jinja






#!stateconf
sls_params:
  stateconf.set:
    - name1: valuASDASDe1
    - name2: value2
    - name3:
      - value1
      - value2
      - value3
    - require_in:
      - cmd: output

# --- end of state config ---

output:
  cmd.run:
    - name: echo {{ "{{ sls_params.name1 }}" }}


      
###########  WTF  ###############
/etc/salt/minion:
  file.managed:
    - template: jinja
    # - context:
    #     cbi_home: 
    - source: salt://etc/salt/minion

