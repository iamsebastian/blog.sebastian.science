#!/bin/bash

echo $1
echo $2

CAPTION=$1'\n%[EXIF:DateTime]'
INPUTFILE=$2

convert -caption $CAPTION $INPUTFILE -font vincHand -fill gray90 -bordercolor gray5 -pointsize 48 -gravity center -background white -polaroid -0 -set filename:foo '%t_' '%[filename:foo].jpg'
