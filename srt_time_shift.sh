#!/bin/bash

usage="Proper Usage: \n \n $(basename "$0") <sourcesrt> <+/-><time difference in seconds>. \n eg - $(basename "$0") /tmp/file.srt +5 \n eg - $(basename "$0") /tmp/file.srt -2.5 \n There is no space between the plus or minus and the time difference. \n"

srcfile="$1"
timediff="$2"
intregex='^[-+][0-9]+([.][0-9]+)?$'


if [ $# -ne 2 ] || ! [[ $timediff =~ $intregex ]] 
then
echo -e "\n Improper variables \n"
echo -e "$usage"
exit 1
fi

shift_time() {
time="$1"

#convert time to seconds

timeinsec=`echo "$time" | awk -F[:,] '{ printf "%.3f\n",($1 * 3600) + ($2*60) + $3 + ($4 / 1000) '$timediff' }'`


#establishing seconds and milliseconds
[[ $timeinsec =~ ([0-9]+)(.?)([0-9]+)? ]]
#echo "Results: $?"
seconds_int=${BASH_REMATCH[1]}
ms=${BASH_REMATCH[3]}

if [[ $ms = "" ]] 
then 
ms=000
fi

#ensure milliseconds are 3 digits
if [[ ${#ms} -eq 2 ]]
then 
((ms=ms*10))
elif [[ ${#ms} -eq 1 ]]
then
((ms=ms*100))
fi


#establish hours, minutes, seconds
((h=seconds_int/ 3600))
((m=(seconds_int%3600)/60))
((s=seconds_int%60))
printf "%02d:%02d:%02d,%s\n" $h $m $s $ms
}


while read -r line
do
# checking if line is a time or text
    if [[ $line =~ ^[0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9]\ --\>\ [0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9].?$ ]]
    then
# reading the times and arrow into variables
        read -r starttime arrow endtime <<<"$line"
        new_start_time="$(shift_time "$starttime")"
        new_end_time="$(shift_time "$endtime")"
        printf "%s %s %s\n" "$new_start_time" "$arrow" "$new_end_time"
    else
        printf "%s\n" "$line" | tr -d '\r'
    fi	
done < "$srcfile"
