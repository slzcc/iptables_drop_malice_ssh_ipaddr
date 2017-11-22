#!/bin/bash

count1=`cat ${PWD}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | wc -l`
count2=0
ss=""
AllPort="0:65535"
IPT="/sbin/iptables"

for i in `cat ${PWD}/iptables_drop_malice_ssh_ipaddr/error_ssh.txt | sort | uniq`; do

  let count2+=1

  for j in `cat ${PWD}/iptables_drop_malice_ssh_ipaddr/accept_account.txt | sort | uniq`; do

    if [ "$j" == "$i" ]; then

      echo "Remove $j Rule!"

      break

    fi

    if [ "${count1}" == "${count2}" ]; then

      ss+="$i"

    else

      ss+="$i",

    fi

  done

done

if [ "$1" == "start" ]; then

  $IPT -t filter -A INPUT -p tcp -s ${ss} --sport ${AllPort} --dport 22 -j DROP

elif [ "$1" == "stop" ]; then

  $IPT -t filter -D INPUT -p tcp -s ${ss} --sport ${AllPort} --dport 22 -j DROP

fi

echo $1 Configure iptables!
