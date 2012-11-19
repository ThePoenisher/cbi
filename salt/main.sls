###########  PATH   ###############
{% set file="/etc/profile" %}
{% if grains['os'] == 'Ubuntu' %}
{% set file="/etc/environment" %}
{% endif %}
if grep -q PATH {{ file }}; then sed -i -re 's/(PATH=".*)"/\1:{{ grains['cbi_home']|replace('/','\/') }}\/bin"/' {{ file }}; else echo PATH=\"{{ grains['cbi_home'] }}/bin\"\; export PATH >> {{ file }}; fi:
  cmd.run:
    - unless: grep -q cbi/bin {{ file }}

echo CBI=\"{{ grains['cbi_home'] }}\"\; export CBI >> /etc/profile:
  cmd.run:
    - unless: grep -q CBI= /etc/profile

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


######### Packages ###########
{% if pillar['arch_desktop'] %}
arch_desktop_packages:
  pkg.installed:
    - names:
      - tree
      - emacs
{% endif %}

########  config files ########
/etc/gitconfig:
  file.managed:
    - template: jinja
    - source: salt://etc/gitconfig