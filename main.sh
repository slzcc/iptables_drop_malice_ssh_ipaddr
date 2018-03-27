#!/bin/bash

workDir="/root"
sourceCount=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | wc -l`
targetCount=0
sourceIPList=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | sort | uniq`
AddIPList=""
DeleteIPList=""
AllPorts="0:65535"
IPT="/sbin/iptables"
suffix="(,$)"

for i in ${sourceIPList}; do

  let targetCount+=1

  AddIPList+="$i",

done

for j in ${sourceIPList}; do

  DeleteIPList+="$j",

done

[[ "$AddIPList" =~ $suffix ]] && AddIPList=${AddIPList%?}

[[ "$DeleteIPList" =~ $suffix ]] && DeleteIPList=${DeleteIPList%?}

if [ "$1" == "start" ]; then

  $IPT -t filter -A INPUT -p tcp -s ${DeleteIPList} --sport ${AllPorts} --dport 22 -j ACCEPT
  $IPT -t filter -A INPUT -p tcp -s ${AddIPList} --sport ${AllPorts} --dport 22 -j DROP


elif [ "$1" == "stop" ]; then

  $IPT -t filter -D INPUT -p tcp -s ${DeleteIPList} --sport ${AllPorts} --dport 22 -j ACCEPT
  $IPT -t filter -D INPUT -p tcp -s ${AddIPList} --sport ${AllPorts} --dport 22 -j DROP

fi

[[ `echo $?` == "0" ]] && echo $1 Configure iptables!
