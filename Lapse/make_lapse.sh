#!/bin/bash

offset=0
limit=1200
dirsrc=/root/snap/
dirdest=/root/lapse/
dirtmp=/tmp/lapseframetmp/
dirweb=/data/www/lapse/
dirshare=/root/Dropbox/MicrosoftSuzhou/
dirpublic=/media/networkshare/stcsuz/lapsevideo/
bgmmp4="$dirdest"song/p2112104.mp4
bgmmp3=/tmp/bgm.mp3
fileavi="$dirdest"timelapse.avi
filemp4="$dirdest"timelapse.mp4
filewmv="$dirdest"timelapse.wmv
arcfile="$dirdest"archive/lapse"$(date '+-%Y_%m_%d-%H_%M_%S')".mp4

if [ $# -ge 1 ];
then
    limit=`expr $1 \* 60`
fi

# start from here
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -fr "$dirtmp"
mkdir "$dirtmp"

# prepare photos
count=0
for filesrc in $(./filter_file.sh "$dirsrc" "$limit" "$offset" 0 24)
do
    count=`expr $count + 1`
    filedest=`printf ""$dirtmp"snap_%.4d.jpg" "$count"`
    ./convert_frame.sh "$filesrc" "$filedest"
done

# generate h264 version video for modern browsers' users
ffmpeg -y -vn -f image2 -i "$dirtmp"snap_%04d.jpg -i "$bgmmp4" -shortest -r 20 -vf scale=1296:-1 -vcodec libx264 -crf 20 -tune stillimage -profile:v high -level 4.2 -acodec aac -ab 128k -strict experimental "$filemp4"

# generate wmv version video for old-fashion browsers' users
ffmpeg -i "$bgmmp4" -y -vn -acodec libmp3lame -ac 2 -ab 128k -ar 48000 "$bgmmp3"
mencoder mf://"$dirtmp"snap*.jpg -mf fps=20:type=jpg -ovc lavc -lavcopts vcodec=wmv2:vbitrate=30720000:trell -vf scale=1296:972 -audiofile "$bgmmp3" -oac mp3lame -o "$filewmv"

# copy to the Web
cp "$filemp4" "$dirweb"alpha.mp4
cp "$filewmv" "$dirweb"alpha.wmv

# archive it
mv "$filemp4" "$arcfile"

# share it
cp "$arcfile" "$dirshare"
cp "$arcfile" "$dirpublic"
