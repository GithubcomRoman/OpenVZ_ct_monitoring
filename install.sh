#!/bin/bash
# install.sh - copy files for OpenVZ_ct_mon
#Zabbix agent 
cp agent_conf/open_vz.conf /etc/zabbix/zabbix_agentd.d/

#Copy scripts

cp agent_scripts/ct_param_name.sh /etc/zabbix/scripts/
cp agent_scripts/ct_param_value.sh /etc/zabbix/scripts/

cp agent_scripts/ct_failcnt_name.sh /etc/zabbix/scripts/
cp agent_scripts/ct_failcnt_value.sh /etc/zabbix/scripts/


chmod -R +x /etc/zabbix/scripts


cp ct_check_v02.sh /root/ct_check_v02.sh && chmod -R +x /root/ct_check_v02.sh
cp ailcnt_count.sh /root/failcnt_count.sh && chmod -R +x /root/failcnt_count.sh