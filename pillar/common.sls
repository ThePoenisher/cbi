{% if grains['cbi_machine'] == 'debussy' %}
zsh_users:
  - root
  - johannes


users:  
  root:
  johannes:


{% elif grains['cbi_machine'] == 'strauss' %}

include:
 - test-gpg

gitolite:
  user: git
  dir: /var/jo/git2
  conf_file: gitolite/strauss.conf.gpg
  authorized_keys: gitolite/strauss.authorized_keys.gpg

zsh_users:
  - root
  

users:  
  root:

{% endif %}