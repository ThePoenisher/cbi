# -*- mode: shell-script; -*-
CBI="{{ grains['cbi_home'] }}"
export CBI

CBI_MACHINE="{{ grains['cbi_machine'] }}"
export CBI_MACHINE


ALTERNATE_EDITOR=""
export ALTERNATE_EDITOR

PATH=$PATH:$CBI/bin
export PATH

eval `keychain --eval -Q /home/johannes/.ssh/id_rsa /home/johannes/.ssh/github-kuerzn`
