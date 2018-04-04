#!/bin/bash
# install.sh - copy files for OpenVZ_ct_mon

#Create directories
mkdir -p /etc/zabbix/zabbix_agentd.d/
mkdir -p /etc/zabbix/scripts/


#Zabbix agent 
cp agent_conf/open_vz.conf /etc/zabbix/zabbix_agentd.d/

#Copy scripts

cp agent_scripts/ct_param_name.sh /etc/zabbix/scripts/
cp agent_scripts/ct_param_value.sh /etc/zabbix/scripts/

cp agent_scripts/ct_failcnt_name.sh /etc/zabbix/scripts/
cp agent_scripts/ct_failcnt_value.sh /etc/zabbix/scripts/


chmod -R +x /etc/zabbix/scripts


cp ct_check_v02.sh /root/ct_check_v02.sh && chmod +x /root/ct_check_v02.sh
cp failcnt_count.sh /root/failcnt_count.sh && chmod +x /root/failcnt_count.sh
cp vzubc_custom.sh /usr/sbin/vzubc_custom && chmod +x /usr/sbin/vzubc_custom

#-----------------| Check install. Checking the availability of files. |--------------------|

echo "|-- Zabbix Agent status:"


[ "$(pgrep zabbix)" ] && echo "+OK - Zabbix agent run" || echo "-FAIL - Zabbix agent run"

FILE[1]="/etc/zabbix/zabbix_agentd.d/open_vz.conf"
FILE[2]="/etc/zabbix/scripts/ct_param_name.sh"
FILE[3]="/etc/zabbix/scripts/ct_param_value.sh"
FILE[4]="/etc/zabbix/scripts/ct_failcnt_name.sh"
FILE[5]="/etc/zabbix/scripts/ct_failcnt_value.sh"
FILE[6]="/root/ct_check_v02.sh"
FILE[7]="/root/failcnt_count.sh"
FILE[8]="/usr/sbin/vzubc_custom"

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

#add task to root crontab

OpenVZ7_CRON="/var/spool/cron/root"
DEBIAN8_CRON="/var/spool/cron/crontabs/root"

if [ ! -f "${OpenVZ7_CRON}" ]; then
        CRONFILE="${OpenVZ7_CRON}"
        else
        CRONFILE="${DEBIAN8_CRON}"
fi

inform_1="# OpenVZ monitoring"
task1="* * * * * /root/./ct_check_v02.sh"
task2="* * * * * /root/./failcnt_count.sh"

echo "${inform_1}" >> ${CRONFILE}
echo "${task1}" >> ${CRONFILE}
echo "${task2}" >> ${CRONFILE}

if [[ `grep "ct_check" "${CRONFILE}"` ]]; then
echo "+OK - add task to root crontab"
else 
echo "-FAIL - add task to root crontab. Make it manual."
echo "Add:"
echo "${task1}"
echo "${task2}"

fi


