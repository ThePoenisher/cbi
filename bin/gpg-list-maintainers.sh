#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../gpg
cat $DIR/repo_maintainers | xargs -I f gpg -k f
