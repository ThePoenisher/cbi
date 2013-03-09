######### Packages ###########
base_packages:
  pkg.installed:
    - names:
      - tree
      - vim
      - htop
      - unzip
      - zip
      - bc
      - iperf
      - pv
      - ethtool
      - rsync
      - iotop
      - sysstat
      - hwinfo
      - wget
      - colordiff
      - figlet
      - ranger
      - subversion
      - w3m
      - lynx
      - unrar
{% if pillar['has_battery'] %}
      - powertop
      - acpi
{% endif %} #battery
{% if grains['os'] == 'Arch' %}
      - p7zip
      - traceroute
      - iptraf-ng
      - iftop
      - tmux
      - rlwrap
      - pkgfile
      - perl-switch
      - perl-dbd-sqlite
      - perl-dbi
      - perl-file-slurp
      - evince
      - auctex
      - texlive-bibtexextra
      - texlive-bin
      - texlive-core
      - texlive-fontsextra
      - texlive-formatsextra
      - texlive-games
      - texlive-genericextra
      - texlive-htmlxml
      - texlive-humanities
      - texlive-latexextra
      - texlive-music
      - texlive-pictures
      - texlive-plainextra
      - texlive-pstricks
      - texlive-publishers
      - texlive-science
      - curlftpfs
      - strace
      - calc
      - python2-pygments
      - nmap #(includes netcat implementation (ncat) with ipv6 support)
      - encfs
      - hunspell-de
      - hunspell-en
      - aspell-de
      - aspell-en
      - expect
      - lftp
      - putty
      - sshfs
      - ntp
{% if pillar['arch_desktop'] %}
      - pdfedit
      - gimp
      - virtualbox
      - virtualbox-host-modules
      - icedtea-web-java7
      - evince
      - mtpfs
      - graphviz
      - thunar
      - zenity
      - ffmpegthumbnailer
# früher      - openjdk6
      - jdk7-openjdk
      - emacs
      - mercurial
      - gptfdisk
      - keychain 
      - skype
      - lib32-libpulse
      - tk #for gitk
      - tightvnc
      - smartmontools
      - hdparm
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
    - require:
      - file: /etc/pacman.conf

/etc/pacman.conf:
  file.append:
    - text: |
        [multilib]
        Include = /etc/pacman.d/mirrorlist

# do I need gvfs. given it limited power.  what does ubuntu use ? gphotos2?
{% for p in ['git-annex-bin','epson-inkjet-printer-workforce-635-nx625-series','perl-string-util','perl-file-find-rule','aurvote','python2-gnupg','mendeleydesktop'] %}
packer --noconfirm --noedit  -S {{ p }}:
  cmd.run:
    - unless: pacman -Q {{ p }}
{% endfor %}

# (cd  /usr/share && curl -O http://downloads.kitenet.net/git-annex/linux/git-annex-standalone-amd64.tar.gz && tar xzf git-annex-standalone-amd64.tar.gz ):
#   cmd.run:
#     - unless: test -d /usr/share/git-annex.linux

{% else %}
      - python-pygments
      - apcalc

git-annex:
  pkg.installed

{% endif %} #archos