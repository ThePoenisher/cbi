#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg
export GNUPGHOME=$DIR/home 
sed 's/$/:6:/' $DIR/repo_maintainers | gpg2 --import-ownertrust
