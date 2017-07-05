#!/bin/bash

INPUTFILE=$1
OUTPUTFILE=./img_generated/$INPUTFILE
CAPSICUM=`cat ./_data/capsicums.yaml | shyaml get-value $2.name`

echo $INPUTFILE
echo $OUTPUTFILE
echo $CAPSICUM

convert \
  $INPUTFILE \
  -resize 1024x768 \
  -font Xenophone \
  -background rgba\(0,0,0,0.8\) \
  -gravity SouthWest \
  -fill rgba\(255,255,255,0.86\) \
  -splice 0x40 -pointsize 24 -annotate 0x0 'capsicum pubescens' \
  -splice 0x50 -pointsize 32 -annotate 0x0 'Rocoto Brown' \
  -splice 0x40 -pointsize 24 -annotate 0x0 '159 Tage alt' \
  -bordercolor black -border 16x16 \
  $OUTPUTFILE
