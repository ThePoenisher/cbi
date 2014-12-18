######### Packages ###########
base_packages:
  pkg.installed:
    - names:
      - tree
      - git
      - tmux
      - screen
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
      - dialog
{% if pillar['has_battery'] %}
      - powertop
      - acpi
{% endif %} #battery
{% if grains['os'] == 'Arch' %}
      - automake
      - libtool
      - evtest
      - p7zip
      - ifplugd
      - dnsutils
      - exfat-utils
      - fuse-exfat
      - syslinux
      - dosfstools
      - socat
      - aria2
      - pass
      - traceroute
      - iptraf-ng
      - iftop
      - rlwrap
      - pkgfile
      - strace
      - calc
      - nmap #(includes netcat implementation (ncat) with ipv6 support)
      - gnu-netcat
      - encfs
      - lftp
      - pacmatic
      - keychain 
      - smartmontools
      - hdparm
      - jdk8-openjdk
      - icedtea-web
      - apache-ant
{% if grains['cbi_machine'] in [ 'debussy', 'scriabin' ] %}
      - cloc
      - ncdu
      - dos2unix
      - reflector
      - pptpclient
      - openconnect
      - cuetools
      - shntool
      - picard
      - zbar
      - chromaprint
      - mac
      - vsftpd
      - cabal-install
      - perl-mime-tools
      - perl-image-exiftool
      - pastebinit
      - python2-eyed3
      - python-html2text
      - inotify-tools
      - perl-rename
      - vbetool
      - perl-switch
      - perl-dbd-sqlite
      - perl-dbi
      - perl-file-slurp
      - auctex
      - dia
      - inkscape
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
      - dmidecode #for salt
      - python2-pip
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
      - alex
      - gtk2hs-buildtools
      - happy
      - net-tools
      - haskell-parsec
      - haskell-edit-distance
      - haskell-utf8-string
      - haskell-mime-types
      - haskell-system-filepath
      - haskell-pretty-show
      - haskell-system-fileio
      - haskell-strict
      - haskell-async
      - haskell-haskell-lexer
      - haskell-attoparsec
      - haskell-pandoc
      - haskell-hxt
      - haskell-either
      - haskell-regex-tdfa
      - haskell-regex-pcre
      - haskell-regex-posix
      - haskell-hslogger
      - haskell-diff
      - haskell-safe
      - haskell-polyparse
      - haskell-th-lift
      - haskell-th-orphans
      - haskell-parallel
      - haskell-regex-compat
      - haskell-split
      - haskell-haskell-src-exts
      - haskell-cassava
      - haskell-persistent
      - haskell-persistent-sqlite
      - haskell-persistent-template
      - haskell-warp
      - haskell-wai-extra
      - haskell-wai-logger
      - haskell-uuid
      - haskell-word8
      - haskell-unix-time
      - haskell-stringsearch
      - haskell-cmdargs
      - haskell-easy-file
      - haskell-byteorder
      - haskell-ansi-terminal
      - haskell-network-info
      - haskell-setenv
      - haskell-base16-bytestring
      - haskell-csv
      # - haskell-haskeline
      # - haddock
      - samba
      - android-tools
      - android-udev
{% endif %} #debussy+scriabin
    - require:
      - file: /etc/pacman.conf
    - sysupgrade: False    

{% if grains['cbi_machine'] in [ 'debussy', 'scriabin' ] %}
# do I need gvfs-mtp-git. given it limited power.  what does ubuntu use ? gphotos2?
#,'git-annex-standalone' use own PKGBUILD instead
# ,'mediathek'
# ,'scid_vs_pc'
# ,'intel-mkl'
{% for p in
['aurvote'
,'chromium-pepper-flash'
,'dbacl'
,'dbvis'
,'downgrade'
,'eigen3-hg'
,'electrum'
,'epson-inkjet-printer-workforce-635-nx625-series'
,'google-talkplugin'
,'jdownloader2' 
,'ledger-git'
,'mediathek'
,'mendeleydesktop'
,'otf-texgyre'
,'pdftk-bin'
,'perl-file-find-rule'
,'perl-string-util'
,'python2-gnupg'
,'python2-pypdf'
,'python2-zbar'
,'scidb'
,'stockfish-git'
,'ttf-vista-fonts'
,'urlview'
,'yed'
] %} #see also bootstrap!!
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

{% elif grains['cbi_machine'] in [ 'kasse3og' ] %} #debussy+scriabin2
{% for p in
[
] %} 
packer --noconfirm --noedit  -S {{ p }}:
  cmd.run:
    - unless: pacman -Q {{ p }}
{% endfor %}
{% endif %} #debussy+scriabin2

{% else %} # not archOS
      - python-pygments
      - apcalc

git-annex:
  pkg.installed

{% endif %} #not archos
