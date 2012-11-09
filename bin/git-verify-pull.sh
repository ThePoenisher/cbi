#!/bin/bash
git fetch $1
./git-verify-commit-signature.sh FETCH_HEAD && git merge FETCH_HEAD

