# -*- mode: shell-script; -*-
CBI="{{ grains['cbi_home'] }}"
export CBI
PATH=$PATH:$CBI/bin
export PATH
eval `keychain --eval -Q github.johannes@debussy`
