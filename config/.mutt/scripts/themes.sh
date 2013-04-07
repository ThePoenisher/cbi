#!/bin/bash
cd ~/.mutt/themes
d=../themes.default
i=$(cat $d)

if [ "$1" = "next" ]; then
		i=$(( $i + 1 ))
elif [ "$1" = "previous" ]; then
		i=$(( $i - 1 ))
fi

[ $i -eq 0 ] && i=10000

echo 'uncolor index *'
echo 'uncolor body *'
echo 'uncolor header *'
my_theme=`find . -type f | sort | sed -n "$i p"`
if [ -z "$my_theme" ]; then
		i=1
		my_theme=`find . -type f | sort | sed -n "$i p"`
fi
echo set my_theme="'[$i] $my_theme'"
echo $i > $d
cat $my_theme
echo set ?my_theme

