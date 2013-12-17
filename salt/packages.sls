######### Packages ###########
base_packages:
  pkg.installed:
    - names:
      - tree
      - git
      - tmux
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
      - lsof
      - w3m
      - parted
      - lynx
      - unrar
{% if pillar['has_battery'] %}
      - powertop
      - acpi
{% endif %} #battery
{% if grains['os'] == 'Arch' %}
      - p7zip
      - dnsutils
      - pptpclient
      - socat
      - aria2
      - vsftpd
      - cabal-install
      - perl-mime-tools
      - perl-image-exiftool
      - pastebinit
      - python2-eyed3
      - pass
      - html2text
      - inotify-tools
      - perl-rename
      - vbetool
      - traceroute
      - iptraf-ng
      - iftop
      - rlwrap
      - pkgfile
      - perl-switch
      - perl-dbd-sqlite
      - perl-dbi
      - perl-file-slurp
      - auctex
      - dia
      - inkscape
      - sqliteman
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
      - expect #(unbuffer)
      - lftp
      - putty
      - sshfs
      - ntp
      - xdialog #for (my) xrename
      # haskell
      - happy
      - net-tools
      - haskell-parsec
      - haddock
      - samba
{% if pillar['arch_desktop'] %}
      - pdfedit
      - bitcoin-qt
      - ntfs-3g
      - bitcoin-daemon
      - calibre
      - aqbanking
      # - wine
      # - winetricks
      - dunst # für libnotify
      - espeak
      - gimp
      - virtualbox
      - virtualbox-host-modules
      - icedtea-web-java7
      - evince
      - mtpfs
      - graphviz
      - thunar
      - tumbler #thumbnails in thunar
      - ffmpegthumbnailer #thumbnails in thunar
      - thunar-archive-plugin
      - zenity #(Display graphical dialog boxes from shell scripts) what for?
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
      - sane
      - xsane
      - xsane-gimp
{% if grains['cbi_machine'] == 'scriabin' %}
      - hplip
{% endif %}
      - gvfs-afc
      - gvfs-afp
      - gvfs-gphoto2 # für andoird phone via usb (geht nicht, doch
                     # besser mtp?)
      - gvfs-mtp
      - gvfs-smb
      - unoconv
{% for p in ['de','en-US','base','calc','draw','impress','math','postgresql-connector','writer','gnome'] %}
      - libreoffice-{{ p }}
{% endfor %}
{% endif %} #archdesktop
    - require:
      - file: /etc/pacman.conf

# do I need gvfs-mtp-git. given it limited power.  what does ubuntu use ? gphotos2?
{% for p in
['aurvote'
,'dbacl'
,'downgrade'
,'electrum'
,'epson-inkjet-printer-workforce-635-nx625-series'
,'git-annex-standalone'
,'google-talkplugin'
,'jdownloader2' 
,'ledger-git'
,'mendeleydesktop'
,'pdftk-bin'
,'perl-file-find-rule'
,'perl-string-util'
,'python2-gnupg'
,'python2-zbar'
,'urlview'
] %}
packer --noconfirm --noedit  -S {{ p }}:
  cmd.run:
    - unless: pacman -Q {{ p }}
{% endfor %}

#CAREFUL: only PKGBUILDs you trust to run as root!
{% for p in [] %} #'git-annex'] %}
makepkg --asroot -i -p {{ grains['cbi_home'] }}/PKGBUILDS/{{ p }} --noconfirm -c:
  cmd.run:
    - unless: pacman -Q {{ p }}
{% endfor %}

# (cd  /usr/share && curl -O http://downloads.kitenet.net/git-annex/linux/git-annex-standalone-amd64.tar.gz && tar xzf git-annex-standalone-amd64.tar.gz ):
#   cmd.run:
#     - unless: test -d /usr/share/git-annex.linux

{% else %} # not archOS
      - python-pygments
      - apcalc

git-annex:
  pkg.installed

{% endif %} #not archos