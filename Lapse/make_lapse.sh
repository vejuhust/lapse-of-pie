#!/bin/sh

limit=480
dirsrc=/root/snap/
dirdest=/root/lapse/
dirtmp=/tmp/lapseframetmp/
dirweb=/data/www/lapse/
bgmmp4="$dirdest"song/p727835.mp4
bgmmp3=/tmp/bgm.mp3
fileavi="$dirdest"timelapse.avi
filemp4="$dirdest"timelapse.mp4
filewmv="$dirdest"timelapse.wmv
arcfile="$dirdest"archive/lapse"$(date '+-%Y_%m_%d-%H_%M_%S')".mp4

rm -fr "$dirtmp"
mkdir "$dirtmp"

# prepare photos
count=0
for filesrc in `ls "$dirsrc"*.jpg | sort -r | head -n "$limit" | sort`
do
    count=`expr $count + 1`
    filedest=`printf ""$dirtmp"snap_%.4d.jpg" "$count"`
    ./convert_frame.sh "$filesrc" "$filedest"
done

# process background music and video
ffmpeg -i "$bgmmp4" -y -vn -acodec libmp3lame -ac 2 -ab 128k -ar 48000 "$bgmmp3"
mencoder mf://"$dirtmp"snap*.jpg -mf fps=20:type=jpg -ovc x264 -x264encopts pass=1:bitrate=3840000:crf=24 -of lavf -lavfopts format=mp4 -audiofile "$bgmmp3" -oac mp3lame -o "$filemp4"

# convert into wmv for Windows users
ffmpeg -i "$filemp4" -y -qscale 0 "$filewmv"

# copy to the Web
cp "$filemp4" "$dirweb"alpha.mp4
cp "$filewmv" "$dirweb"alpha.wmv

# archive it
mv "$filemp4" "$arcfile"
