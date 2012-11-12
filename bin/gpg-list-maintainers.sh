#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg
export GNUPGHOME=$DIR/home 
cat $DIR/repo_maintainers | xargs -I f gpg -k f
