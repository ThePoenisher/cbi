#!/bin/bash

icons=/home/johannes/cbi/desktop-artwork/icons

tf=/tmp/conkyrc`uuidgen`
cat <<EOF > $tf
gap_y -1000
double_buffer yes 
out_to_console yes 
own_window yes 
own_window_type desktop
update_interval 1.0 

TEXT
A='\${time %R}'
CPU='\${cpu cpu0}'
MEM='\$memperc'
DISKIO='\$diskio'
TRAF='^i($icons/sm4tik/arch.xbm) \${entropy_avail}/\${entropy_poolsize} \
^fg(\#ebac54) \${if_existing /proc/net/route eth0} \
^i($icons/sm4tik/net_wired.xbm) \
^fg(\#00aa4a)\
^i($icons/sm4tik/net_down_03.xbm)\${downspeed eth0}\
^fg(\#ff3333) \
^i($icons/sm4tik/net_up_03.xbm)\${upspeed eth0} \
\${endif}\
^fg(\#ebac54)\${if_existing /proc/net/route wlan0}\
^i($icons/sm4tik/wifi_01.xbm) \
^fg(\#00aa4a)\
^i($icons/sm4tik/net_down_03.xbm)\${downspeed wlan0}\
^fg(\#ff3333)\
^i($icons/sm4tik/net_up_03.xbm)\${upspeed wlan0} \
\${endif}'
DATE='^fg(\#cc99ff)\${if_existing /sys/class/power_supply/BAT0/uevent}\
^i(/home/johannes/cbi/desktop-artwork/icons/sm4tik/bat_full_01.xbm)\
\${battery_short} \${battery_time}\
\${endif} \
^fg(\#ebac54) \
^i(/home/johannes/cbi/desktop-artwork/icons/sm4tik/clock.xbm) \
^fg(\#FFFFFF) \${time %A %d.%m.%Y} \
^fg(\#ebac54) \${time %X}'
EOF



conky -c $tf | (
while read l
do
		VOL=`amixer get Master | egrep -o "[0-9]+%\] \[[^]]+" | head -1`
		VOL2=$(echo `egrep -o [0-9]* <<< $VOL`" / 1.53" | bc)
		eval $l
		echo -n \
" ^i($icons/sm4tik/diskette.xbm) $DISKIO"     \
" $TRAF "                                     \
"^fg(#ffffff)^i($icons/sm4tik/cpu.xbm) $CPU% "\
" ^i($icons/sm4tik/mem.xbm) $MEM% " 
 #`gdbar -s o -fg '#ebac54' <<< $CPU ` \
#`gdbar -s o <<< $MEM`

echo -n "  ^fg(#00ffff)^i($icons/sm4tik/spkr_01.xbm)"
if [[ $VOL =~ off ]]; then
		echo -n 'M'
fi
#`gdbar -s o -fg '#00ffff' <<< $VOL2 `\
echo " $VOL2% "\
     "$DATE "
done
)
