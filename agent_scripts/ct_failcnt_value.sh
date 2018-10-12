#!/bin/bash
param=$1

cat /etc/zabbix/scripts/ct_failcnt_value.txt | grep "$param " | awk '{print $2}'