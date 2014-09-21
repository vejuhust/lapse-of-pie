#!/bin/sh

filename=snap"$(date '+-%Y_%m_%d-%H_%M_%S')".jpg

cd /root/snapshot/
if [ "r" = "$1" ];
then
    raspistill -rot 180 -o "$filename"
else
    raspistill -o "$filename"
fi
