#!/bin/bash

fps=30
crf=18
width=1296
song=p2112104.mp4
#convert=cp

dirsrc=/root/fy16/selected/
dirdest=/root/fy16/result/
dirtmp=/tmp/fy16lapseframetmp"$model"/
dirpublic=/media/networkshare/stcsuz/sharing/fy16video/
bgmmp4=/root/fy16/song/"$song"
filemp4="$dirdest"timelapse.mp4
arcfile="$dirdest"fy16-clip"$(date '+-%Y_%m_%d-%H_%M_%S')".mp4

# start from here
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -fr "$dirtmp"
mkdir "$dirtmp"

# prepare photos
count=0
for filesrc in $(ls "$dirsrc"*.jpg | sort -r)
do
    count=`expr $count + 1`
    filedest=`printf ""$dirtmp"snap_%.4d.jpg" "$count"`
    ./convert_frame.sh "$filesrc" "$filedest" "$convert"
done

# generate h264 version video for modern browsers' users
ffmpeg -y -vn -f image2 -i "$dirtmp"snap_%04d.jpg -i "$bgmmp4" -shortest -r "$fps" -vf scale="$width":-1 -vcodec libx264 -crf "$crf" -tune stillimage -profile:v high -level 4.2 -acodec aac -ab 128k -strict experimental "$filemp4"

# archive & share it
mv -v "$filemp4" "$arcfile"
cp -v "$arcfile" "$dirpublic"
