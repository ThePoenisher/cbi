
########### fonts #############

fc-cache:
  cmd.wait:
    - watch:
      - file: yesb
      - file: nob
      - file: fconf
        
yesb:
  file.symlink:
    - name:  /etc/fonts/conf.d/70-no-bitmaps.conf
    - target: /etc/fonts/conf.avail/70-no-bitmaps.conf
    - force: True
      
nob:
  file.absent:
    - name: /etc/fonts/conf.d/70-yes-bitmaps.conf
      

fconf:
  file.managed:
    - source: salt://etc/fonts_local.conf
    - name: /etc/fonts/local.conf
    - template: jinja
      
###### packages #######
fonts:
  pkg.installed:
    - names:
        - ttf-bitstream-vera    
        - ttf-liberation
        - ttf-dejavu
        - ttf-droid
        - ttf-ubuntu-font-family
        - ttf-freefont
        - xorg-xfontsel
        - xorg-fonts-100dpi
        - xorg-fonts-75dpi
        - gtk2fontsel
        - terminus-font
#        - monaco  sehr hässlich, z.B. in Firefox
#        see also packer

packer --noconfirm --noedit  -S ttf-ms-fonts:
  cmd.run:
    - unless: pacman -Q ttf-ms-fonts
