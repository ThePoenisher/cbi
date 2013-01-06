###########  Profile   ###############
{% if grains['os'] == 'Arch' %}
/etc/profile.d/cbi.sh:
  file.managed:
    - source: salt://etc/profile.d-cbi.sh
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
      - vboxusers
    - require:
      - group: sudo
{% endif %}


{% if grains['cbi_machine'] == 'strauss' %}
g:
  user.present:
    - shell: /usr/bin/git-annex-shell
    - home: /var/jo/git

org:
  user.present:
    - home: /var/jo/mobileorg
    - password: {{ pillar['org.password'] }} 
{% endif %}


####### services ########
{% if grains['os'] == 'Arch' %}
{% if grains['cbi_machine'] == 'debussy' %}
dhcpcd@eth0:
  service.running:
    - enable: true
    - watch:
      - file: /etc/dhcpcd.conf
{% endif %} #debussy

cronie:
  service.running:
    - enable: True

systemd-logind:
  service.running:
    - watch:
      - file: /etc/systemd/logind.conf
{% endif %} # arch

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

/etc/systemd/logind.conf:
  file.managed:
    - template: jinja
    - source: salt://etc/systemd-logind.conf
      
## fstab
/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=de-latin1
    - makedirs: True
    
      
{% set files = ['locale.gen','mkinitcpio.conf','fstab','gitconfig' ] %}
{% for file in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}
    - template: jinja
{% endfor %}

locale-gen:
  cmd.wait:
    - watch:
      - file: /etc/locale.gen


/usr/lib/systemd/system-sleep/lock.sh:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/system-sleep-lock.sh
    - force: True

### kernel
mkinitcpio -p linux:
  cmd.wait:
    - watch:
      - file: /etc/mkinitcpio.conf
        
######  Symlinked Files  #########
{% set files = ['locale.conf','vimrc','modules-load.d','fuse.conf' ] %}
{% for file in files %}
/etc/{{ file }}:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/'+file }}
    - force: True
{% endfor %}
      
/etc/udevil/udevil.conf:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/udevil.conf' }}
    - force: True
      
########  network ###########
hostnamectl set-hostname {{ grains['cbi_machine'] }}:
  cmd.run:
    - unless: test `hostname` = "{{ grains['cbi_machine'] }}"

##### printing ####
cups:
  service.running:
    - enable: True

  
{% endif %} #ARCH OS
