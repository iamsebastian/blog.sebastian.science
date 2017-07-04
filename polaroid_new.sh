#!/bin/bash

echo $1
echo $2

CAPTION=$1'\n%[EXIF:DateTime]'
INPUTFILE=$2

convert -repage +10+5 -caption $CAPTION $INPUTFILE -font vincHand -gravity center -sharpen 10 -fill gray90 -bordercolor snow -pointsize 48 -gravity center -background grey20 +polaroid -background transparent -flatten MIFF:- | convert MIFF:- -resize 400% -set filename:foo '%t_' '%[filename:foo].jpg' | convert MIFF:- -resize 25% -set filename:foo '%t_' '%[filename:foo].jpg'
