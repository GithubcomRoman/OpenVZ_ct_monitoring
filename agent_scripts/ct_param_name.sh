#!/bin/bash
#JSON=$(for i in `cat /etc/zabbix/scripts/ct_param_name.txt`; do printf "{\"{#CT_PARAM_NAME}\":\"$i\"},"; done | sed 's/^\(.*\).$/\1/')
JSON=$(for i in `cat /etc/zabbix/scripts/ct_param_value.txt | awk '{print $1}' `; do printf "{\"{#CT_PARAM_NAME}\":\"$i\"},"; done | sed 's/^\(.*\).$/\1/')
printf "{\"data\":["
printf "$JSON"
printf "]}"
