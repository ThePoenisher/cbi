# disable saa7134 IR (Terratec Cinergy 40
# xinput --disable "saa7134 IR (Terratec Cinergy 40"
sudo sh -c "echo 1 > /sys/bus/pci/devices/0000:`lspci | sed -nre 's/([^ ]*) .*SAA7134.*/\1/p'`/remove"
