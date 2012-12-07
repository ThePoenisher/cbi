# -*- mode: shell-script; -*-
CBI="{{ grains['cbi_home'] }}"
CBI_MACHINE="{{ grains['cbi_machine'] }}"
export CBI
export CBI_MACHINE
PATH=$PATH:$CBI/bin
export PATH
eval `keychain --eval -Q /home/johannes/.ssh/id_rsa`
