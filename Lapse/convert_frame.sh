#!/bin/sh

filelogo=logo.png
filesrc="$1"
filedest="$2"

# apt-get install imagemagick
composite -dissolve 75% -gravity northwest -geometry +50+50 \( "$filelogo" -thumbnail 50% \) "$filesrc" "$filedest"
