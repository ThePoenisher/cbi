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
      - html2text
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
      # haskell
      - alex
      - gtk2hs-buildtools
      - happy
      - net-tools
      - haskell-parsec
      - haskell-async
      - haskell-haskell-lexer
      - haskell-attoparsec
      - haskell-pandoc
      - haskell-hxt
      - haskell-regex-tdfa
      - haskell-regex-posix
      - haskell-hslogger
      - haskell-safe
      - haskell-polyparse
      - haskell-th-lift
      - haskell-th-orphans
      - haskell-parallel
      - haskell-regex-compat
      - haskell-regex-tdfa
      - haskell-regex-pcre
      - haskell-regex-posix 
      - haskell-split
      - haskell-haskell-src-exts
      - haskell-cassava
      # - haskell-haskeline
      # - haddock
      - samba
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
,'dbacl'
,'downgrade'
,'eigen3-hg'
,'electrum'
,'epson-inkjet-printer-workforce-635-nx625-series'
,'google-talkplugin'
,'jdownloader2' 
,'ledger-git'
,'mendeleydesktop'
,'otf-texgyre'
,'pdftk-bin'
,'perl-file-find-rule'
,'perl-string-util'
,'python2-gnupg'
,'python2-zbar'
,'scidb'
,'stockfish-git'
,'ttf-vista-fonts'
,'urlview'
,'dbvis'
,'yed'
,'mediathek'
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

{% endif %} #debussy+scriabin2
{% else %} # not archOS
      - python-pygments
      - apcalc

git-annex:
  pkg.installed

{% endif %} #not archos
