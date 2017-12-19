#!/bin/bash

sourceCount=`cat ${PWD}/malice_ssh_list.txt | wc -l`
targetCount=0
IPList=""
AllPorts="0:65535"
IPT="/sbin/iptables"
suffix="(,$)"

for i in `cat ${PWD}/malice_ssh_list.txt | sort | uniq`; do

  let targetCount+=1

  for j in `cat ${PWD}/neglect_ssh_list.txt | sort | uniq`; do

    if [ "$j" == "$i" ]; then

      echo "Remove $j Rule!"

      break

    fi

    if [ "${sourceCount}" == "${targetCount}" ]; then

      IPList+="$i"

    else

      IPList+="$i",

    fi

  done

done

[[ "$IPList" =~ $suffix ]]; IPList=${IPList%?}

if [ "$1" == "start" ]; then

  $IPT -t filter -A INPUT -p tcp -s ${IPList} --sport ${AllPorts} --dport 22 -j DROP

elif [ "$1" == "stop" ]; then

  $IPT -t filter -D INPUT -p tcp -s ${IPList} --sport ${AllPorts} --dport 22 -j DROP

fi

[[ `echo $?` == "0" ]]; echo $1 Configure iptables!
