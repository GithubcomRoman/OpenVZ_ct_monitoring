#!/bin/bash
JSON=$(for i in `cat /etc/zabbix/scripts/ct_failcnt_value.txt | awk '{print $1}' `; do printf "{\"{#CT_FAILCNT_NAME}\":\"$i\"},"; done | sed 's/^\(.*\).$/\1/')
printf "{\"data\":["
printf "$JSON"
printf "]}"

