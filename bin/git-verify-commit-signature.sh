#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
key=""
key=$(git log --format="format:" -n 1 --show-signature $1 | sed -nr 's/^\[GNUPG:\] VALIDSIG ([0-9A-F]{40}) .*/\1/p')
test -n "$key" && grep -B 2 -A 1 $key $DIR/../gpg-keys/repo_authorization_keys

