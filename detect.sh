#!/bin/bash
# filename: intruder_detect.sh
# function: intruder detect, read from auth.log by default
AUTHLOG=/var/log/auth.log

if [ -n "$1" ]; then
    AUTHLOG=$1
    echo Using log file: $AUTHLOG
fi
LOG=/tmp/valid.$$.log
grep -vi "invalid" $AUTHLOG | grep "Failed password" > $LOG
users=`grep "Failed password" $LOG | awk '{print $(NF-5)}' | sort -u`

printf "%-5s|%-10s|%-10s|%-13s|%-13s|%s\n" \
    "Sr#" "User" "Attemps" "IP Address" "Host_Mapping" "Time range"

ucount=0
ip_list="$(grep -o "[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}\>" $LOG | sort -u)"

for ip in $ip_list; do
    grep "$ip" $LOG > /tmp/temp.$$.log
    for user in $users; do
        grep $user /tmp/temp.$$.log > /tmp/$$.log
        cut -c-16 /tmp/$$.log > $$.time
        tstart=$(head -n1 $$.time)
        start=$(date -d "$tstart" "+%s")
        tend=$(tail -n1 $$.time)
        end=$(date -d "$tend" "+%s")
        limit=$(( $end - $start ))
        if [ $limit -gt 120 ]; then
            let ucount++
            IP=$(grep -o "[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}\>" \
                /tmp/$$.log | head -n1)
            TIME_RANGE="$tstart--> $tend"
            ATTEMPTS=$(cat /tmp/$$.log | wc -l)
            HOST=$(host $IP | awk '{print $NF}')

            printf "%-5s|%-10s|%-10s|%-13s|%-13s|%s\n" \
                "$ucount" "$user" "$ATTEMPTS" "$IP" "$HOST" "$TIME_RANGE"
        fi
    done
done

rm /tmp/valid.$$.log /tmp/$$.log $$.time /tmp/temp.$$.log
