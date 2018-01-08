#!/bin/bash

workDir="/root"
sourceCount=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | wc -l`
targetCount=0
IPList=""
AllPorts="0:65535"
IPT="/sbin/iptables"
suffix="(,$)"

for i in `cat ${workDir}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | sort | uniq`; do

  let targetCount+=1

  for j in `cat ${workDir}/iptables_drop_malice_ssh_ipaddr/neglect_ssh_list.txt | sort | uniq`; do

    if [ "$j" == "$i" ]; then

      echo "Remove $j Rule!"

      break

    fi

    IPList+="$i",

  done

done

[[ "$IPList" =~ $suffix ]] && IPList=${IPList%?}

if [ "$1" == "start" ]; then

  $IPT -t filter -A INPUT -p tcp -s ${IPList} --sport ${AllPorts} --dport 22 -j DROP

elif [ "$1" == "stop" ]; then

  $IPT -t filter -D INPUT -p tcp -s ${IPList} --sport ${AllPorts} --dport 22 -j DROP

fi

[[ `echo $?` == "0" ]] && echo $1 Configure iptables!
