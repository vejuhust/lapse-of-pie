#!/bin/bash

dirsrc="$1"
limit="$2"
offset="$3"

index_head=`expr $limit + $offset`
index_tail=`expr $limit`

ls "$dirsrc"*.jpg | sort -r | head -n "$index_head" | tail -n "$index_tail" | sort
