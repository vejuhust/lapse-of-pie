#!/bin/bash

if [ $# -ge 1 ];
then
    model="$1"
else
    model=c
fi

case "$model" in
c )
    day_offset=0
    day_limit=1
    hour_min=4
    hour_max=20
    fps=30
    crf=19
    song=p2112104.mp4
    ;;
d )
    day_offset=0
    day_limit=1
    hour_min=4
    hour_max=22
    fps=20
    crf=20
    song=p2112104.mp4
    ;;
w )
    day_offset=0
    day_limit=5
    hour_min=6
    hour_max=18
    fps=30
    crf=21
    song=p667730.mp4
    ;;
*)
    echo "invalid model"
    exit 2
    ;;
esac

offset=$(expr '(' $hour_max - $hour_min ')' \* $day_offset \* 60)
limit=$(expr '(' $hour_max - $hour_min ')' \* $day_limit \* 60)
dirsrc=/root/snap/
dirdest=/root/lapse/
dirtmp=/tmp/lapseframetmp"$model"/
dirweb=/data/www/lapse/
dirshare=/root/Dropbox/MicrosoftSuzhou/
dirpublic=/media/networkshare/stcsuz/lapsevideo/
bgmmp4="$dirdest"song/"$song"
bgmmp3=/tmp/bgm.mp3
fileavi="$dirdest"timelapse.avi
filemp4="$dirdest"timelapse.mp4
filewmv="$dirdest"timelapse.wmv
arcfile="$dirdest"archive/lapse"$(date '+-%Y_%m_%d-%H_%M_%S')".mp4
dayfile="$dirweb"archive/lapse"$(date '+-%Y_%m_%d')".mp4

# start from here
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -fr "$dirtmp"
mkdir "$dirtmp"

# prepare photos
count=0
for filesrc in $(./filter_file.sh "$dirsrc" "$limit" "$offset" "$hour_min" "$hour_max")
do
    count=`expr $count + 1`
    filedest=`printf ""$dirtmp"snap_%.4d.jpg" "$count"`
    ./convert_frame.sh "$filesrc" "$filedest"
done

# generate h264 version video for modern browsers' users
ffmpeg -y -vn -f image2 -i "$dirtmp"snap_%04d.jpg -i "$bgmmp4" -shortest -r "$fps" -vf scale=1296:-1 -vcodec libx264 -crf "$crf" -tune stillimage -profile:v high -level 4.2 -acodec aac -ab 128k -strict experimental "$filemp4"

# generate wmv version video for old-fashion browsers' users
ffmpeg -i "$bgmmp4" -y -vn -acodec libmp3lame -ac 2 -ab 128k -ar 48000 "$bgmmp3"
mencoder mf://"$dirtmp"snap*.jpg -mf fps="$fps":type=jpg -ovc lavc -lavcopts vcodec=wmv2:vbitrate=30720000:trell -vf scale=1296:972 -audiofile "$bgmmp3" -oac mp3lame -o "$filewmv"

# copy to the Web
if [ "c" != "$model" ];
then
    cp "$filemp4" "$dirweb"alpha.mp4
    cp "$filewmv" "$dirweb"alpha.wmv
fi

if [ "d" = "$model" ];
then
    cp "$filemp4" "$dayfile"
fi

# archive it
mv "$filemp4" "$arcfile"

# share it
cp "$arcfile" "$dirshare"
cp "$arcfile" "$dirpublic"
