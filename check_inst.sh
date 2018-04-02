#!/bin/bash

echo "|--Check Zabbix Agent activ..."


[ "$(pgrep zabbix)" ] && echo "+OK - Zabbix agent run" || echo "-FAIL - Zabbix agent run"

FILE[1]="/etc/zabbix/zabbix_agentd.d/open_vz.conf"
FILE[2]="/etc/zabbix/scripts/ct_param_name.sh"
FILE[3]="/etc/zabbix/scripts/ct_param_value.sh"
FILE[4]="/etc/zabbix/scripts/ct_failcnt_name.sh"
FILE[5]="/etc/zabbix/scripts/ct_failcnt_value.sh"
FILE[6]="/root/ct_check_v02.sh"
FILE[7]="/root/failcnt_count.sh"

echo "|--Check openZV config for Zabbix Agent..."
if [ ! -f "${FILE[1]}" ]; then
    echo "-FAIL - /etc/zabbix/zabbix_agentd.d/open_vz.conf"
       # exit 1;
        
        else 
        echo "+OK - /etc/zabbix/zabbix_agentd.d/open_vz.conf"
fi


echo "|--Check scripts for Zabbix Agent..."

for ((count=2; count <= ${#FILE[*]}; count++))
do
if [ ! -f "${FILE[$count]}" ]; then
    echo "-FAIL - ${FILE[$count]} - not found!"
       # exit 1;
        
        else 
        echo "+OK - ${FILE[$count]}"
fi

done
