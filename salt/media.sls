sound_packages:
{% if pillar['arch_desktop'] %}
  pkg.installed:
    - names:
      - alsa-utils
      - pulseaudio
      - pulseaudio-alsa
      #GUI
      - pavucontrol
      - mplayer2
      - vlc
{% if grains['cbi_machine'] == 'scriabin' %}
{% endif %}
{% endif %}