#!/bin/bash

filelogo=logo.png
filesrc="$1"
filedest="$2"
filetmp=/tmp/framewt.jpg

# get file name
name=${filesrc##*snap}

# get date string
dateyear=$(echo "$name" | cut -d '-' -f 2 | cut -d '_' -f 1)
datemonth=$(echo "$name" | cut -d '-' -f 2 | cut -d '_' -f 2)
dateday=$(echo "$name" | cut -d '-' -f 2 | cut -d '_' -f 3)
datehour=$(echo "$name" | cut -d '-' -f 3 | cut -d '_' -f 1)
datemin=$(echo "$name" | cut -d '-' -f 3 | cut -d '_' -f 2)
timestamp=$(printf "%s/%s/%s %s:%s" "$datemonth" "$dateday" "$dateyear" "$datehour" "$datemin")

# apt-get install imagemagick
composite -dissolve 75% -gravity northwest -geometry +50+50 \( "$filelogo" -thumbnail 50% \) "$filesrc" "$filetmp"

# add time stamp
convert -size 700x100 xc:none -gravity west \
        -stroke black -strokewidth 10 -font Noteworthy.ttc -pointsize 54 -annotate 0 "$timestamp" \
        -background none -shadow 100x3+0+0 +repage \
        -stroke none -fill white -font Noteworthy.ttc -pointsize 54 -annotate 0 "$timestamp" \
        "$filetmp" +swap -gravity northwest -geometry +50+180 \
        -composite "$filedest"
