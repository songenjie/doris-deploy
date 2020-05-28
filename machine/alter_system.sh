#! /bin/bash
set -x
# $1 FOLLOWER/OBSERVER/BACKEND/BROKER 
# $2 ADD/DROP
# $3 master $ip
# $4 master port
# $5 port 9510  9550 9580
# $6 file
# ./sql.sh FOLLOWER  ADD hostname 9230 9510 ht0_40/ht0_40_fe_follower 
# ./sql.sh OBSERVER  ADD hostname 9230 9510 ht0_40/ht0_40_fe_observer 
# ./sql.sh BACKEND   ADD hostname 9230 9550 ht0_40/ht0_40_be 
# ./sql.sh BROKER    ADD hostname 9230 8500 ht0_40/ht0_40_broker 

for ip in $(cat  ./$6 )
do
	echo $ip 
	if [[ "$1" == "BROKER" ]]	
	then
		mysql -h $3 -P$4 -uroot -e "ALTER SYSTEM $2 $1 hdfs \"$ip:$5\"" 
	else
		mysql -h $3 -P$4 -uroot -e "ALTER SYSTEM $2 $1 \"$ip:$5\"" 
	fi
	echo  $ip done
done
