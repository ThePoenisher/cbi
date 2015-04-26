###########  Profile   ###############
/etc/zsh/zprofile:
  file.managed:
    - source: salt://etc/zsh/zprofile
    - template: jinja

/etc/profile.d/cbi.sh:
  file.managed:
    - source: salt://etc/profile.d-cbi.sh
    - template: jinja
    - mode: 755

{% if pillar['users']['root'] is defined %}
root:
  user.present:
    - shell: /bin/zsh
{% endif %}

####### services ########
{% if grains['os'] == 'Arch' %}
{% if grains['cbi_machine'] in [] %}
dhcpcd@eth0:
  service.running:
    - enable: true
    - watch:
      - file: /etc/dhcpcd.conf
{% endif %}

ntp:
  pkg:
    - installed
  service:
    - name: ntpd
    - running
    - enable: true
    - require:
      - pkg: ntp
#    - watch:
#      - file: /etc/ntp.conf

cronie:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: cronie

systemd-logind:
  service.running:
    - watch:
      - file: /etc/systemd/logind.conf
        
/etc/dhcpcd.conf:
  file.append:
    - text: clientid  #für Fritzbox etc
      
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
    - template: jinja
    - source: salt://etc/sudoers
    - user: root
    - mode: 400
      

locale-gen:
  cmd.wait:
    - watch:
      - file: /etc/locale.gen

### kernel
mkinitcpio -p linux:
  cmd.wait:
    - watch:
      - file: /etc/mkinitcpio.conf

#######  managed etc (template) files #######
{% set files =
[('fstab','')
,('gitconfig','')
,('locale.gen','')
,('makepkg.conf','')
,('udevil/udevil.conf','')
,('mkinitcpio.conf','')
,('modules-load.d/cbi.conf','')
,('pacman.conf','')
,('systemd/journald.conf','')
,('systemd/logind.conf','')
,('zsh/zshenv','')
] %}
{% for file,ending in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}{{ ending }}
    - makedirs: True
    - template: jinja
{% endfor %}

######  Symlinked etc Files  #########
{% set files =
['gitignore'
,'locale.conf'
,'tmux.conf'
,'vimrc'
 ] %}
{% for file in files %}
/etc/{{ file }}:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/'+file }}
    - force: True
{% endfor %}


########  network ###########
hostnamectl set-hostname {{ grains['cbi_machine'] }}:
  cmd.run:
    - unless: test `hostname` = "{{ grains['cbi_machine'] }}"

##### pacman #### 
/etc/pacman.d/mirrorlist:
  file.managed:
    - source: salt://etc/pacman.d/mirrorlist.gpg

{% endif %} # arch