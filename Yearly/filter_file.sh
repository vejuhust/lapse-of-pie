#!/bin/bash

if [ $# -lt 5 ];
then
    printf "arguments missing, needs 5 \n"
    exit 1
fi

dirsrc="$1"
limit="$2"
offset="$3"
hour_min="$4"
hour_max="$5"

index_head=`expr $limit + $offset`
index_tail=`expr $limit`

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
