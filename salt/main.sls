###########  env (see also zshenv)    ###############
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
,'.android'
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


####### config #####
{% if grains['os'] == 'Arch' %}
      
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
[('kismet.conf','')
,('minidlna.conf','')
,('udev/rules.d/99-discharge.rules','')
,('netctl/wlan0-SBB','')
,('netctl/wlan0-eduroam','')
,('netctl/wlan0-chris-KDG-C32A4','.gpg')
,('netctl/hotsplots-7ZsIdg2wumfNziS.key','.gpg')
,('netctl/wlan0-test','.gpg')
,('samba/smb.conf','')
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

/usr/lib/systemd/system-sleep/lock.sh:
  file.managed:
    - source: salt://system-sleep-lock.sh
    - template: jinja
    - mode: 755

        
### udev ruleskernel
udevadm control --reload-rules:
  cmd.wait:
    - watch:
      - file:   /etc/udev/rules.d/99-discharge.rules
        
######  Symlinked etc Files  #########
{% set files =
['fuse.conf'
] %}
{% for file in files %}
/etc/{{ file }}:
  file.symlink:
    - target: {{ grains['cbi_home']+'/config/'+file }}
    - force: True
{% endfor %}
      
##### printing ####
cups:
  service.running:
    - names:
      - org.cups.cupsd
      - cups-browsed
    - enable: True
      

##### Systemd services

{% if pillar['arch_desktop'] %}

{% set services =
[
('getty@'           ,true ,['tty1']    ,['systemd/system/getty@tty1.service.d/autologin.conf'])
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
    - makedirs: true
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
    - disabled
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