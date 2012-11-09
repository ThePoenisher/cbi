#!/bin/bash
gpg2 -k --with-colons --with-fingerprint $1
#| sed -ne 's/fpr:*\([^:]*\):$/\1/p'
