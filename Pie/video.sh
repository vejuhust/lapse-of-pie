#!/bin/sh

cd /root/video/

filename_index_offset=1
filename=clip$(date '+-%Y_%m_%d-%H_%M_%S-')$(printf "%.3d" $(expr $filename_index_offset + $(ls *.h264 | wc -l)))-$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
file_h264="$filename".h264
file_mp4="$filename".mp4

if [ $# -ge 1 ];
then
    limit_sec="$1"
else
    limit_sec=60
fi

limit=$(expr $limit_sec \* 1000)

raspivid -rot 180 -t "$limit" -o "$file_h264"
ffmpeg -i "$file_h264" -r 30 -vcodec copy "$file_mp4"
