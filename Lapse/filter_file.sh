#!/bin/bash

dirsrc="$1"
limit="$2"
offset="$3"

index_head=`expr $limit + $offset`
index_tail=`expr $limit`

hour_min=0
hour_max=24

for filename in $(ls "$dirsrc"*.jpg | sort -r)
do
    name=${filename##*snap}
    datehour=$(echo "$name" | cut -d '-' -f 3 | cut -d '_' -f 1)
    datemin=$(echo "$name" | cut -d '-' -f 3 | cut -d '_' -f 2)
    if [ "$datehour" -ge "$hour_min" -a "$datehour" -lt "$hour_max" ];
    then
        raw_list+=($filename)
    fi
done

printf -- '%s\n' "${raw_list[@]}" | head -n "$index_head" | tail -n "$index_tail" | sort
