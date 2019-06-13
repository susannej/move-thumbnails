#!/bin/sh
#
# Move image files which doesn't meet a minimum dimension to another directory
# Needs the "identify" command from the imagemagick package
#
# Copyright 2019, Susanne Jaeckel
#
# use at your own risk!
#

if [ $# -ne 2 ]; then
	echo "usage: $0 <max-size> <target-directory>"
	echo "example: $0 500 /home/myhome/blubber"
	exit
fi

# following default-value is tested under FreeBSD
GREP="grep -o -E"

if [ `uname` = 'Linux' ]; then
    GREP="grep -o -P"
fi

echo "Searching for images which are not greater than $1 in any direction"

if [ ! -e $2 ]; then
	echo "$2 doesn't exist, creating!"
	mkdir -p -v "$2"
fi

for i in `find . -name "*" -exec file {} \; | $GREP "^.+: \w+ image" | sed -e "s/: .*//"`
do
	w=`identify -format "%w" "$i"`
	h=`identify -format "%h" "$i"`
	if [ $w -le $1 -a $h -le $1 ]; then
        TARGETDIR=$2/`dirname $i`
        if [ ! -e $TARGETDIR ]; then
            echo "Target directory for image doesn't exist, creating ..."
            mkdir -p -v $TARGETDIR
        fi
		echo "Moving $i ..."
		mv "$i" "$2/$i"
	fi
done
