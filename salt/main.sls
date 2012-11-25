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
      - video
    - require:
      - group: sudo
{% endif %}





####### services ########
{% if grains['os'] == 'Arch' %}
{% if grains['cbi_machine'] == 'debussy' %}
dhcpcd@eth0:
  service.running:
    - enable: true
    - watch:
      - file: /etc/dhcpcd.conf
{% endif %}

cronie:
  service.running:
    - enable: True

{% endif %}

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
{% if grains['os'] == 'Arch' %}
/etc/dhcpcd.conf:
  file.append:
    - text: clientid

      
/etc/gitconfig:
  file.managed:
    - template: jinja
    - source: salt://etc/gitconfig

/etc/default/grub:
  file.managed:
    - template: jinja
    - source: salt://etc/grub

grub-mkconfig -o /boot/grub/grub.cfg:
  cmd.wait:
    - watch:
        - file: /etc/default/grub
      

/etc/sudoers:
  file.managed:
    - source: salt://etc/sudoers
    - user: root
    - mode: 400

## fstab
sed -i -re '/\/home/s|(/home\W*ext4\W*)|\1noauto,x-systemd.automount,|' /etc/fstab:
  cmd.run:
    - unless: grep -q systemd.automount /etc/fstab

    
{% endif %} #ARCH OS

/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=de-latin1
    - makedirs: True
      
### locale ####
/etc/locale.gen:
  file.managed:
    - source: salt://etc/locale.gen

locale-gen:
  cmd.wait:
    - watch:
      - file: /etc/locale.gen

/etc/locale.conf:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/locale.conf
    - force: True


######  Symlinked Files  #########
/etc/vimrc:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/vimrc' }}
    - force: True
      
########  network ###########
hostnamectl set-hostname {{ grains['cbi_machine'] }}:
  cmd.run:
    - unless: test `hostname` = "{{ grains['cbi_machine'] }}"

