######### Packages ###########
{% if grains['os'] == 'Arch' %}
/etc/pacman.conf:
  file.append:
    - text: |
        [multilib]
        Include = /etc/pacman.d/mirrorlist

arch_desktop_packages:
  pkg.installed:
    - require:
      - file: /etc/pacman.conf
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
      - wget
      - python2-pygments
{% if pillar['has_battery'] %}
      - powertop
      - acpi
{% endif %} #battery
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
      - zathura-pdf-mupdf
      - zathura-ps
      - zathura-djvu
      - kdegraphics-gwenview
      - oxygen-icons
{% for p in ['de','en-US','base','calc','draw','impress','math','postgresql-connector','writer','gnome'] %}
      - libreoffice-{{ p }}
{% endfor %}


{% endif %} #archdesktop

        
{% endif %} #archos