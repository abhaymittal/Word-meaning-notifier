#!/bin/bash
#Bash Script which accepts a list of words and notifies on regular intervals (set by user) by picking a random word from the list and displaying its meaning along with some example sentences from Oxford dictionary website using American English.

# Author: Abhay Mittal
source xmlextract.sh
filename=$1
line_num=$2
base_url="http://www.oxforddictionaries.com/definition/american_english/"
awk "NR > $line_num" "$filename" |
while read line
do
    echo $line
    word=$(echo $line | awk '{print $1}')
    word=$(echo $word | tr '[:upper:]' '[:lower:]')
    url="$base_url$word"
    page_source=$(curl "$url")
    res_ht="$(xml_extract "$page_source")"
    res="$(echo $res_ht | lynx -stdin -nolist -dump)"
    res=$(echo "$res" | sed 's/.*/&\r/g')
    echo "$res"
    notify-send "`printf "$res"`"
    sleep 15m

done
