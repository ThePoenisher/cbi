#!/bin/bash
#Remove puncatation, linebreaks, trailing whitespaces, and seperatewords by one whitespace
tr  '\n' ' '  | sed -e 's/./\L\0/g;s/\W\+/ /g;s/\W*$//g'

