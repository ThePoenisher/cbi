{% if grains['cbi_machine'] in [ 'scriabin' ] %}
has_battery: True
{% else %}
has_battery: False
{% endif %}
{% if grains['cbi_machine'] in [ 'debussy', 'scriabin' ] %}

arch_desktop: True
desktop_user: johannes

zsh_users:
  - root
  - johannes
  - daniela

ssh_users_with_auth_keys:
  - johannes

users:  
  root:
  johannes:
  daniela:


{% elif grains['cbi_machine'] == 'strauss' %}

arch_desktop: False

include:
 - test-gpg

gitolite:
  user: git
  dir: /var/jo/git2
  conf_file: gitolite/strauss.conf.gpg
  authorized_keys: gitolite/strauss.authorized_keys.gpg

zsh_users:
  - root


ssh_users_with_auth_keys:
  - root
  - org
  
users:  
  root:

{% elif grains['cbi_machine'] == 'kasse3og' %}
zsh_users:
  - root
  - kasse

ssh_users_with_auth_keys:
  - root

desktop_user: kasse

users:  
  root:
  kasse:

eth0: enp2s8 

{% endif %}