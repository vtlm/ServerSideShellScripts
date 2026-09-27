#!/bin/bash
#. ./functions.sh


while true
do
	printf  "hey stupid\n"
	res=$(mbim-network /dev/cdc-wdm0 stop)
#	printf $((res))
printf "%s\n" "${res[@]}"
	sleep 1
done


#for ((;;))
#while :
#do
	res=$(mbim-network /dev/cdc-wdm0 stop)
	printf $((res))
	sleep 4
	res=$(mbim-network /dev/cdc-wdm0 stop)
	printf $((res))
	sleep 4
	res=$(mbim-network /dev/cdc-wdm0 stop)
	printf $((res))
	sleep 4
	res=$(mbim-network /dev/cdc-wdm0 stop)
	printf $((res))
	sleep 4
	res=$(mbim-network /dev/cdc-wdm0 stop)
	printf $((res))
	sleep 4

#done
