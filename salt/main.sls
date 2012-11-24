###########  PATH   ###############
{% if grains['os'] == 'Arch' %}
/etc/profile.d/cbi.sh:
  file.managed:
    - source: salt://etc/profile
    - template: jinja
      
{% elif grains['os'] == 'Ubuntu' %}
{% set file="/etc/environment" %}
if grep -q PATH {{ file }}; then sed -i -re 's/(PATH=".*)"/\1:{{ grains['cbi_home']|replace('/','\/') }}\/bin"/' {{ file }}; else echo PATH=\"{{ grains['cbi_home'] }}/bin\"\; export PATH >> {{ file }}; fi:
  cmd.run:
    - unless: grep -q cbi/bin {{ file }}

echo CBI=\"{{ grains['cbi_home'] }}\"\; export CBI >> /etc/profile:
  cmd.run:
    - unless: grep -q CBI= /etc/profile
{% endif %}


      
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
      - optical
      - network
      - scanner
      - power
      - storage
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
      - iotop
      - sysstat
      - hwinfo
{% if pillar['arch_desktop'] %}
      - emacs
      - keychain 
      - skype
      - lib32-libpulse
      - tk #for gitk
      - tightvnc
      - smartmontools
      - cdrkit #cds brennen: https://wiki.archlinux.org/index.php/CD_Burning
      - udevil
{% for p in ['de','en-US','base','calc','draw','impress','math','postgresql-connector','writer','gnome'] %}
      - libreoffice-{{ p }}
{% endfor %}
{% endif %}
{% if pillar['has_battery'] %}
      - powertop
      - acpi
{% endif %}
    - require:
      - file: /etc/pacman.conf




####### services ########
{% if grains['cbi_machine'] == 'debussy' %}
dhcpcd@eth0:
  service.running:
    - enable: true
    - watch:
      - file: /etc/dhcpcd.conf
{% endif %}

sshd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config

cronie:
  service.running:
    - enable: True


{% if pillar['arch_desktop'] %}
{% for i in [1] %}
getty@tty{{ i }}:
  service.disabled

autologin@tty{{ i }}:
  service.enabled:
    - require:
      - file: autologin
{% endfor %}


autologin:
  file.managed:
    - source: salt://autologin@.service
    - name: /etc/systemd/system/autologin@.service
{% endif %}

####### config #####
/etc/dhcpcd.conf:
  file.append:
    - text: clientid

/etc/ssh/sshd_config:
  file.append:
    - text: X11Forwarding yes

{% endif %}

/etc/default/grub:
  file.managed:
    - template: jinja
    - source: salt://etc/grub

grub-mkconfig -o /boot/grub/grub.cfg:
  cmd.wait:
    - watch:
        - file: /etc/default/grub
      
/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=de-latin1
    - makedirs: True
      
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

