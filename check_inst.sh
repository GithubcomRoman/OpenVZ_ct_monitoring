#!/bin/bash

echo "|--STAGE -1: check openZV config for Zabbix Agent...|"


[ "$(pgrep zabbix)" ] && echo "|+++++Zabbix agent run - OK" || echo "|+++++Zabbix agent run - NO"

echo "|--STAGE -2: check scripts for Zabbix Agent...|"

FILE[1]="/etc/zabbix/zabbix_agentd.d/open_vz.conf"


if [ ! -f "${FILE[1]}" ]; then
    echo "open_vz.conf not set!"
	exit 1;
	
	else 
	echo "|+++++ /etc/zabbix/zabbix_agentd.d/open_vz.conf - OK"
fi






cp agent_scripts/ct_param_name.sh /etc/zabbix/scripts/
cp agent_scripts/ct_param_value.sh /etc/zabbix/scripts/

cp agent_scripts/ct_failcnt_name.sh /etc/zabbix/scripts/
cp agent_scripts/ct_failcnt_value.sh /etc/zabbix/scripts/