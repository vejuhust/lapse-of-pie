#!/bin/bash

tmpdir=/tmp/stream/

mkdir "$tmpdir"
while true
do
    raspistill -w 1024 -h 768 -q 80 -o "$tmpdir"pic.jpg -tl 100 -t 7200000 -th 0:0:0
done
