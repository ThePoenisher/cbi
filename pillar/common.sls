{% if grains['cbi_machine'] == 'debussy' %}
zsh_users:
  - root
  - johannes


users:  
  root:
  johannes:


{% elif grains['cbi_machine'] == 'strauss' %}

gitolite:
  user: git
  dir: /var/jo/git2
  conf_file: strauss_gitolite.conf

zsh_users:
  - root
  

users:  
  root:

{% endif %}