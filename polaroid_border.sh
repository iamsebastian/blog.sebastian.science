#!/bin/bash

INPUTFILE=$1
FILENAME=${INPUTFILE##*/}
OUTPUTFILE=./img_generated/$FILENAME
CAPSICUM_NAME=`cat ./_data/capsicums.yaml | shyaml get-value $2.name`
CAPSICUM_SPROUT=`cat ./_data/capsicums.yaml | shyaml get-value $2.sprout`
CAPSICUM_TYPE=`cat ./_data/capsicums.yaml | shyaml get-value $2.type`

SPROUT_TS=`date -d $CAPSICUM_SPROUT +%s`
NOW_TS=`date +%s`

CAPTURE_DATETIME=`exiv2 -qPt $INPUTFILE | awk /[0-9]{4}:[0-9]{2}:[0-9]{2}/ | awk 'NR==1' | awk /[0-9]{4}/  | awk '{split($0,d,":"); print d[1]"-"d[2]"-"substr(d[3],0,2)}'`

CAPTURE_TS=`date -d $CAPTURE_DATETIME +%s`

DIFF_TS=$(($CAPTURE_TS - $SPROUT_TS))
DIFF_TS_DAYS=$(($DIFF_TS / 60 / 60 / 24))

echo $INPUTFILE
echo $OUTPUTFILE
echo $CAPSICUM_NAME
echo $CAPSICUM_SPROUT
echo $SPROUT_TS
echo $NOW_TS
echo $DIFF_TS
echo $DIFF_TS_DAYS
echo $CAPTURE_DATETIME

DIFF_STR="Alter: $DIFF_TS_DAYS Tage    gekeimt: ${CAPSICUM_SPROUT:0:10}"

echo $DIFF_STR

convert \
  $INPUTFILE \
  -sharpen 1 \
  -resize 1024x768 \
  -background hsl\(202,111,23\) \
  -fill rgba\(255,255,255,0.86\) \
  -gravity SouthWest \
  -font Bushcraft-distress \
  -splice 0x56 -pointsize 32 -annotate 0x0 "$CAPSICUM_NAME" \
  -font something-wild \
  -gravity SouthEast \
  -pointsize 30 -annotate 0x0 "Foto: $CAPTURE_DATETIME" \
  -gravity SouthWest \
  -splice 0x40 -pointsize 30 -annotate 0x0 "$CAPSICUM_TYPE" \
  -font something-wild \
  -gravity SouthEast \
  -pointsize 30 -annotate 0x0 "$DIFF_STR" \
  -gravity SouthEast \
  -font Thunder \
  -fill hsla\(255,255,255,0.3\) \
  -splice 0x16 -pointsize 72 -annotate 0x0 'f' \
  -bordercolor hsl\(202,111,23\) \
  -border 16x16 \
  $OUTPUTFILE
