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
      - audio
      - mail
    - require:
      - group: sudo
{% endif %}


######### Packages ###########
{% if grains['os'] == 'Arch' %}
/etc/pacman.conf:
  file.append:
    - text: |
        [multilib]
        Include = /etc/pacman.d/mirrorlist

arch_desktop_packages:
  pkg.installed:
    - names:
      - tree
      - vim
      - htop
      - unzip
      - zip
      - calc
      - bc
      - iperf
      - pv
      - ethtool
      - rsync
{% if pillar['arch_desktop'] %}
      - emacs
      - skype
      - lib32-libpulse
      - tk #for gitk
      - tightvnc
{% endif %}
{% if pillar['has_battery'] %}
      - powertop
      - acpi
{% endif %}




####### config #####
/etc/dhcpcd.conf:
  file.append:
    - text: clientid

/etc/ssh/sshd_config:
  file.append:
    - text: X11Forwarding yes

####### services ########
sshd.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config



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


######  Symlinked Files  #########
/etc/vimrc:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/vimrc' }}
    - force: True
      
########  network ###########
hostnamectl set-hostname {{ grains['cbi_machine'] }}:
  cmd.run:
    - unless: test `hostname` = "{{ grains['cbi_machine'] }}"

# TODO
# - LC_CTYPE (z.B. in pinentry-curses)
# - locale @ scriabon
# - GPG_TTY setzen
# - pinentry selection gpg-agent
# ssh and gpg agents too many!
# https://wiki.archlinux.org/index.php/Laptop#Power_Management
# https://wiki.archlinux.org/index.php/Power_saving
