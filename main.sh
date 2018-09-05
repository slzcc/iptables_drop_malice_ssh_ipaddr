#!/bin/bash

workDir="/root"
whiteList=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/neglect_ssh_list.txt | sort | uniq`
blackList=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | sort | uniq`
BlackIPList=""
WhiteIPList=""
AllPorts="0:65535"
IPT="/sbin/iptables"
suffix="(,$)"

for i in ${blackList}; do

  BlackIPList+="$i",

done

for j in ${whiteList}; do

  WhiteIPList+="$j",

done

[[ "$BlackIPList" =~ $suffix ]] && BlackIPList=${BlackIPList%?}

[[ "$WhiteIPList" =~ $suffix ]] && WhiteIPList=${WhiteIPList%?}

if [ "$1" == "start" ]; then

  $IPT -t filter -A INPUT -p tcp -s ${WhiteIPList} --sport ${AllPorts} --dport 22 -j ACCEPT
#  $IPT -t filter -A INPUT -p tcp -s ${BlackIPList} --sport ${AllPorts} --dport 22 -j DROP
for i in ${blackList}; do

  $IPT -t filter -A INPUT -p tcp -s $i --sport ${AllPorts} --dport 22 -j DROP

done


elif [ "$1" == "stop" ]; then

  $IPT -t filter -D INPUT -p tcp -s ${WhiteIPList} --sport ${AllPorts} --dport 22 -j ACCEPT
#  $IPT -t filter -D INPUT -p tcp -s ${BlackIPList} --sport ${AllPorts} --dport 22 -j DROP
for i in ${blackList}; do

  $IPT -t filter -D INPUT -p tcp -s $i --sport ${AllPorts} --dport 22 -j DROP

done

fi

[[ `echo $?` == "0" ]] && echo $1 Configure iptables!
