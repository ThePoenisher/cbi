sound_packages:
{% if pillar['arch_desktop'] %}
  pkg.installed:
    - names:
      - alsa-utils
      - pulseaudio
      - pulseaudio-alsa
      #GUI
      - paprefs
      - pavucontrol
      - mplayer
      - mpv #new mplayer2
      - vlc
      - gecko-mediaplayer
      - rtmpdump
      - lirc-utils
      - minidlna
      - rygel
      - xbmc
{% if grains['cbi_machine'] == 'scriabin' %}
{% endif %}
{% endif %}