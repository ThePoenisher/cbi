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

###########  Groups ###############
sudo:
  group.present:
    - system: True

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
    - groups:
      - sudo
    - require:
      - group: sudo
{% endif %}


######### Packages ###########
{% if grains['os'] == 'Arch' %}
arch_desktop_packages:
  pkg.installed:
    - names:
      - tree
      - vim
      - htop
{% if pillar['arch_desktop'] %}
      - emacs
{% endif %}
{% endif %}

########  config files ########
/etc/gitconfig:
  file.managed:
    - template: jinja
    - source: salt://etc/gitconfig
      
/etc/sudoers:
  file.managed:
    - source: salt://etc/sudoers
    - user: root
    - mode: 400

########  network ###########
hostnamectl set-hostname {{ grains['cbi_machine'] }}:
  cmd.run:
    - unless: test `hostname` = "{{ grains['cbi_machine'] }}"

# TODO
# - LC_CTYPE (z.B. in pinentry-curses)
# - locale @ scriabon
# - GPG_TTY setzen
# - pinentry selection gpg-agent