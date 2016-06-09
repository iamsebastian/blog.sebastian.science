#!/bin/bash

function resample {
  gmic -input $1 -resize2dx $2,6 -gimp_balance_gamma 127,127,95,1,0 -gimp_emulate_film_instant_pro 3,1,0,1,0,0,0,1,0 -o $3,92;
}

echo -n "Please enter prefix for to-be-created files: "
read prefix

# Append "_" to prefix for optical split.
if [ ! -z "$prefix" ]
then
  prefix=$prefix"_";
fi

for i in `ls -1|grep jpg`;
do
  base_name="../img/$prefix"`echo $i|tr -d '.jpg'`;
  full_file=$base_name".jpg";
  first_file=$base_name"_750x.jpg";
  second_file=$base_name"_365x.jpg";

  echo "Will now convert image: $i to $full_file, $first_file and $second_file";

  # Apply film emulation, resize to 750px X and move to ../img dir with quality 92%.
  resample $i 750 $first_file
  # ... also resize to 365px X, for display two images next to each other.
  resample $i 365 $second_file
  # ... and add full_file for download
  resample $i 1536 $full_file

  # Delete file, ONLY, if the $full_file was written.
  if [ -f $full_file ]
  then
    echo "Full file was written."
    rm $i
    if [ ! -f $i ]
    then
      echo "Source file was deleted."
    fi
  fi
done;
