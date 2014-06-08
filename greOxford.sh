#Bash Script which accepts a list of words and notifies on regular intervals (set by user) by picking a random word from the list and displaying its meaning along with some example sentences from Oxford dictionary website using American English.

# Author: Abhay Mittal

filename=$1

while read line
do
    word=$(echo $line | awk '{print $1}')
    echo $word

done < "$filename"
