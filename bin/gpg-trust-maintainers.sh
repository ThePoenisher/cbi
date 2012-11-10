#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg
sed 's/$/:6:/' $DIR/repo_maintainers | gpg2 --import-ownertrust  --homedir $DIR/home
