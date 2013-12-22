#!/usr/bin/python2

import sys

if len(sys.argv) != 3:
    print "<SSID> <MAC>"
    sys.exit(1)

SSID = sys.argv[1]
MAC = sys.argv[2].replace(":", "").replace("-", "").upper()

for X in range(0, 10):
    for Y in range(0, 10):
        for Z in range (0, 10):
            print "SP-" + SSID[9] + str(Z) + SSID[10] + MAC[9:12] + str(X) + str(Y) + str(Z)

