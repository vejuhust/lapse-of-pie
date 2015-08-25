#!/bin/bash

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -sc|--skip-copy)
            SKIP_COPY=1
            ;;
        -sp|--skip-prepare)
            SKIP_PREPARE=1
            ;;
        -sm|--skip-make)
            SKIP_MAKE=1
            ;;
        -sw|--skip-watermark)
            SKIP_WATERMARK=1
            ;;
        *)
            ;;
    esac
    shift # past argument or value
done

fps=24
crf=18
width=1296
song=p2126727.mp4
if [[ $SKIP_WATERMARK ]];
then
    echo "skip adding watermark to photos"
    convert=cp
fi

rootdir=/root/fy16/
dirsrc="$rootdir"selected/
dirdest="$rootdir"result/
dirtmp=/tmp/fy16lapseframetmp/
dirpublic=/media/networkshare/stcsuz/sharing/fy16video/
bgmmp4="$rootdir"song/"$song"
filemp4="$dirdest"timelapse.mp4
arcfile="$dirdest"fy16-clip"$(date '+-%Y_%m_%d-%H_%M_%S')".mp4

# start from here
cd "$( dirname "${BASH_SOURCE[0]}" )"

# copy photos
if [[ $SKIP_COPY ]];
then
    echo "skip copying photos"
else
    rm -fr "$dirsrc"
    cp -v copy-yearly-photo.py "$rootdir"
    python3 "$rootdir"copy-yearly-photo.py
fi

# prepare photos
if [[ $SKIP_PREPARE ]];
then
    echo "skip preparing photos"
else
    rm -fr "$dirtmp"
    mkdir "$dirtmp"

    count=0
    for filesrc in $(ls "$dirsrc"*.jpg)
    do
        count=`expr $count + 1`
        filedest=`printf ""$dirtmp"snap_%.4d.jpg" "$count"`
        ./convert_frame.sh "$filesrc" "$filedest" "$convert"
    done
fi

# create video and upload
if [[ $SKIP_MAKE ]];
then
    echo "skip making video"
else
    # generate h264 version video for modern browsers' users
    ffmpeg -y -vn -f image2 -i "$dirtmp"snap_%04d.jpg -r "$fps" -i "$bgmmp4" -shortest -vf scale="$width":-1 -vcodec libx264 -crf "$crf" -tune stillimage -profile:v high -level 4.2 -acodec aac -ab 128k -strict experimental "$filemp4"

    # archive & share it
    mv -v "$filemp4" "$arcfile"
    cp -v "$arcfile" "$dirpublic"
fi
