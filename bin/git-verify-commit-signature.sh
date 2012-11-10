#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg
export GNUPGHOME=$DIR/home 
gpg2 --import $DIR/public-keys/* > /dev/null 2>&1
key=""
key=$(git log --format="format:" -n 1 --show-signature $1 | sed -nr 's/^\[GNUPG:\] VALIDSIG ([0-9A-F]{40}) .*/\1/p')
echo "The commit is signed by the following maintainer:"
test -n "$key" && grep $key $DIR/repo_maintainers 

# NEEDS TO RETURN non zero is the commit is not signed by a maintainer
