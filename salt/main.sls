###########  PATH   ###############
sed -i -re 's/(PATH=".*)"/\1:{{ grains['cbi_home']|replace('/','\/') }}\/bin"/' /etc/environment:
  cmd.run:
    - unless: grep -q cbi/bin /etc/environment

###########  Users ###############

{% if pillar['users']['root'] is defined %}
root:
  user.present:
    - shell: /bin/zsh
{% endif %}


{% if pillar['users']['johannes'] is defined %}
johannes:
  user.present:
    - shell: /bin/zsh
{% endif %}