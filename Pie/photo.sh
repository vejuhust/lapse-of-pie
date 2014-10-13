#!/bin/sh

filename=snap"$(date '+-%Y_%m_%d-%H_%M_%S')".jpg

cd /root/snapshot/
raspistill  -tl 200 -t 30000 -o "$filename"
