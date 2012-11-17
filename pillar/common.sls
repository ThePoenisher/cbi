{% if grains['cbi_machine'] == 'debussy' %}
zsh_users:
  - root
  - johannes


users:  
  root:
  johannes:


{% elif grains['cbi_machine'] == 'strauss' %}


zsh_users:
  - root


users:  
  root:

{% endif %}