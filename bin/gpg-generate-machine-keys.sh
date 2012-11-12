#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg

number=$1
machine=$2
master=3F32253F910D2BB2B20742BCA7942AEDE1A4B3DB
target=$DIR/public-keys

_gen(){
    local descr[0]="Local Access on $machine"
    local descr[1]="Restricted Access on $machine"
    local descr[2]="Private Access on $machine"
    local email=j$number@$machine
gpg --batch --s2k-cipher-algo AES256 --s2k-digest-algo SHA512 --default-preference-list "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed" --gen-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: Johannes
Name-Comment: ${descr[$number]} 
Name-Email: $email
EOF



id=0x$(gpg2 --with-fingerprint --with-colons -k "<$email>" | grep fpr: | sed -e 's/fpr:.*\([^:]\{8,8\}\):$/\1/g')

gpg -a --export-secret-keys -o - "<$email>" | gpg -e -a -r master > $DIR/../backup-vault/$email-$id-sec.asc
gpg -a --export -o $target/$email-$id-pub.asc $DIR/public-keys/"<$email>"
gpg2 --passwd -o "<$email>"

echo "Created two files starting with  $target/$email-$id-... in the current dir"
}

_gen
