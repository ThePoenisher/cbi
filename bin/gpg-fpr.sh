#!/bin/bash
gpg2 -k $1 1>&2
gpg2 -k --with-colons --with-fingerprint $1 | sed -ne 's/fpr:*\([0-9A-F]\{40\}\):$/\1/p'
