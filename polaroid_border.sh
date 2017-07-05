#!/bin/bash

INPUTFILE=$1
OUTPUTFILE=./img_generated/$INPUTFILE
CAPSICUM_NAME=`cat ./_data/capsicums.yaml | shyaml get-value $2.name`
CAPSICUM_SPROUT=`cat ./_data/capsicums.yaml | shyaml get-value $2.sprout`

SPROUT_TS=`date -d $CAPSICUM_SPROUT +%s`
NOW_TS=`date +%s`
DIFF_TS=$(($NOW_TS - $SPROUT_TS))
DIFF_TS_DAYS=$(($DIFF_TS / 60 / 60 / 24))

echo $INPUTFILE
echo $OUTPUTFILE
echo $CAPSICUM_NAME
echo $CAPSICUM_SPROUT
echo $SPROUT_TS
echo $NOW_TS
echo $DIFF_TS
echo $DIFF_TS_DAYS

DIFF_STR="$DIFF_TS_DAYS Tage alt"

convert \
  $INPUTFILE \
  -resize 1024x768 \
  -font Xenophone \
  -background rgba\(0,0,0,0.8\) \
  -gravity SouthWest \
  -fill rgba\(255,255,255,0.86\) \
  -splice 0x40 -pointsize 24 -annotate 0x0 'capsicum pubescens' \
  -splice 0x50 -pointsize 32 -annotate 0x0 'Rocoto Brown' \
  -splice 0x40 -pointsize 24 -annotate 0x0 "$DIFF_STR" \
  -bordercolor black -border 16x16 \
  $OUTPUTFILE
