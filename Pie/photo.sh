#!/bin/sh

cd /root/snapshot/
raspistill -rot 180 -o snap"$(date '+-%Y_%m_%d-%H_%M_%S')".jpg
