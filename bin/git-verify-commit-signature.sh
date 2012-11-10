#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg
export GNUPGHOME=$DIR/home 
gpg2 --import $DIR/public-keys/* > /dev/null 2>&1
key=""
key=$(git log --format="format:" -n 1 --show-signature $1 | sed -nr 's/^\[GNUPG:\] VALIDSIG ([0-9A-F]{40}) .*/\1/p')
test -n "$key" && grep -B 2 -A 1 $key $DIR/repo_authorization_keys

