#!/bin/bash
# failcnt_count.sh - count errors in CT
echo "" > /etc/zabbix/scripts/ct_failcnt_value.txt
vz=`/usr/sbin/vzlist | awk '{print $1}' | grep -e "[[:digit:]]"`
for machine in $vz; do
        counters=`/usr/sbin/vzctl exec $machine cat /proc/user_beancounters | sed '/[Ve]rsion/d' | sed s/....://g | sed s/uid//g |\
        awk '{print $1,$6}' | grep -e "[[:digit:]]" | \
        awk '{print $1,$2}'`

                for param in $counters; do

                        if [ `echo $param | grep -e "[[:digit:]]" | wc -l` -lt 1 ]
                        then unset value; unset name; name=$param
                        else value=$param
                        fi

                        if [ `echo $value | grep -e "[[:digit:]]" | wc -l` -gt 0 ]
                        then key=${name}${machine}; bytes=${#value};


                        if (($param > 0)); then
                        echo "${key}_failcnt $param" >> /etc/zabbix/scripts/ct_failcnt_value.txt
                        #echo "key - ${key}_failcnt :: param - $param"
fi

                fi

                done
done
