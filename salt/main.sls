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

{% if grains['os'] == 'Ubuntu' %}
{% set file="/etc/environment" %}
if grep -q PATH {{ file }}; then sed -i -re 's/(PATH=".*)"/\1:{{ grains['cbi_home']|replace('/','\/') }}\/bin"/' {{ file }}; else echo PATH=\"{{ grains['cbi_home'] }}/bin\"\; export PATH >> {{ file }}; fi:
  cmd.run:
    - unless: grep -q cbi/bin {{ file }}

echo CBI=\"{{ grains['cbi_home'] }}\"\; export CBI >> /etc/profile:
  cmd.run:
    - unless: grep -q CBI= /etc/profile
{% endif %}

############  Login ##########
{% if grains['os'] == 'Arch' %}
{% set usr = "johannes" %}
{% set home = salt['cmd.run']("bash -c 'echo ~{0}'".format(usr))  %}
{% set files =
['.config/dunst'
,'.config/MusicBrainz'
,'.lircrc'
,'.zlogin'
,'.xbmc/userdata/Lircmap.xml'
,'.xbmc/userdata/advancedsettings.xml'
,'.xbmc/userdata/guisettings.xml'
,'.xbmc/userdata/keymaps/remote.xml'
,'.xbmc/userdata/sources.xml'
,'.scidvspc'
] %}
{% for file in files %}
{{ home }}/{{ file }}:
  file.symlink:
    - target: {{ grains['cbi_home'] }}/config/{{ file }}
    - user: {{ usr }}
    - group: {{ usr }}
    - makedirs: true
    - force: True
{% endfor %}
      
'{{ home }}/VirtualBox VMs':
  file.symlink:
    - target: /home/data/VMs
    - user: {{ usr }}
    - group: {{ usr }}
    - force: True
      
'{{ home }}/.gnupg/gpg.conf':
  file.managed:
    - mode: 600
    - user: johannes
    - template: jinja
    - source: salt://gpg.conf.gpg
  
      
###########  Groups ###############
groupsasd:
  group.present:
    - system: True
    - names:
        - sudo
        - wireshark
        - kismet
{% endif %} # arch

###########  Users ###############
{% if pillar['users']['root'] is defined %}
root:
  user.present:
    - shell: /bin/zsh
{% endif %}

{% if pillar['users']['daniela'] is defined %}
# geht irgendwie nicht
daniela:
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
      - kismet
      - power
      - storage
      - video
      - vboxusers
      - wireshark
    - require:
      - group: sudo
      - group: wireshark
      - group: kismet
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

# strauss etc files      
{% set files =
[
'vsftpd.conf'
] %}
{% for file in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}
    - makedirs: True
    - template: jinja
{% endfor %}

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


ntpd:
  service.running:
    - enable: true
#    - watch:
#      - file: /etc/ntp.conf

cronie:
  service.running:
    - enable: True

systemd-logind:
  service.running:
    - watch:
      - file: /etc/systemd/logind.conf
{% endif %} # arch


####### config #####
{% if grains['os'] == 'Arch' %}
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
    - source: salt://etc/sudoers
    - user: root
    - mode: 400
      
## fstab
/etc/vconsole.conf:
  file.append:
    - text: KEYMAP=de-latin1
    - makedirs: True
    
## samba
sambaservices:
  service.running:
    - names:
        - smbd
        - nmbd
    - enable: true
    - watch:
      - file: /etc/samba/smb.conf

      
#######  managed etc (template) files #######
{% set files =
[('fstab','')
,('gitconfig','')
,('kismet.conf','')
,('locale.gen','')
,('makepkg.conf','')
,('minidlna.conf','')
,('mkinitcpio.conf','')
,('modules-load.d/cbi.conf','')
,('netctl/wlan0-SBB','')
,('netctl/wlan0-eduroam','')
,('netctl/wlan0-chris-KDG-C32A4','.gpg')
,('netctl/hotsplots-7ZsIdg2wumfNziS.key','.gpg')
,('netctl/wlan0-test','.gpg')
,('pacman.conf','')
,('samba/smb.conf','')
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
#######  managed etc files #######
{% set files =
[
'texmf/web2c/texmf.cnf'
] %}
{% for file in files %}
/etc/{{ file }}:
  file.managed:
    - source: salt://etc/{{ file }}
    - makedirs: True
{% endfor %}

locale-gen:
  cmd.wait:
    - watch:
      - file: /etc/locale.gen



/usr/lib/systemd/system-sleep/lock.sh:
  file.managed:
    - source: salt://system-sleep-lock.sh
    - template: jinja
    - mode: 755

### kernel
mkinitcpio -p linux:
  cmd.wait:
    - watch:
      - file: /etc/mkinitcpio.conf
        

        
######  Symlinked etc Files  #########
{% set files =
['fuse.conf'
,'gitignore'
,'locale.conf'
,'tmux.conf'
,'udevil/udevil.conf'
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



##### printing ####
cups:
  service.running:
    - enable: True
      

##### pacman #### 
/etc/pacman.d/mirrorlist:
  file.managed:
    - source: salt://etc/pacman.d/mirrorlist.gpg

##### Systemd services

{% if pillar['arch_desktop'] %}

{% set services =
[('autologin@'       ,true ,['tty1']    ,['systemd/system/autologin@.service'])
,('wol@'             ,true ,['eth0']    ,['systemd/system/wol@.service'])
,('dm-crypt-suspend' ,false,['']        ,['systemd/system/dm-crypt-suspend.service'])
,('mycapsremap'      ,true ,['']        ,['systemd/system/mycapsremap.service'])
,('resume@'          ,true ,['johannes'],['systemd/system/resume@.service'])
,('iptables'         ,true ,['']        ,['iptables/iptables.rules'])
,('lirc'             ,true ,['']        ,['systemd/system/lirc.service','lirc/lircd.conf'])
]%}
#### ('offlineimap',['']) ] %}
###, ('maildir_watch',['']) ] %}
{% for service, start, instances, confs in services %}
{% for conf in confs %}
/etc/{{ conf }}:
  file.managed:
    - template: jinja
    - source: salt://etc/{{ conf }}
{% endfor %}
      
{% for instance in instances %}
{{ service~instance }}:
  service:
{% if start %}
    - running
    - enable: True
{% else %}
    - enabled
{% endif %}
    - watch:
      - cmd: systemd-reload-{{service~instance}}
{% for conf in confs %}
      - file: /etc/{{ conf }}
{% endfor %}

        
systemd-reload-{{service~instance}}:
  cmd.wait:
    - name: systemctl --system daemon-reload
    - watch:
{% for conf in confs %}
      - file: /etc/{{ conf }}
{% endfor %}
{% endfor %}

{% endfor %}

{% endif %} # arch desktop
{% endif %} #ARCH OS