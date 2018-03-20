#!/bin/bash
# ttl for memcached, in seconds. If null, then never expire
 ttl=0
 addr=10.10.10.241
 port=11211
 ### main()
echo "" > /etc/zabbix/scripts/ct_param_value.txt

vz=`/usr/sbin/vzlist | awk '{print $1}' | grep -e "[[:digit:]]"`
#echo "VZ :: $vz"
#echo "----------------------"
for machine in $vz; do
        counters=`/usr/sbin/vzctl exec $machine cat /proc/user_beancounters | sed '/[Ve]rsion/d' | sed s/....://g | sed s/uid//g |\
        awk '{print $1,$2}' | grep -e "[[:digit:]]" | \
        awk '{print $1,$2}'`
#echo "::###::..........CT MACHINE - $machine"
#echo "counters - $counters"

#        echo "stage1"

                for param in $counters; do

                        if [ `echo $param | grep -e "[[:digit:]]" | wc -l` -lt 1 ]
                        then unset value; unset name; name=$param
                        else value=$param
                        fi
#echo "param - $param"
#echo "stage2"

                        if [ `echo $value | grep -e "[[:digit:]]" | wc -l` -gt 0 ]
                        then key=${name}${machine}; bytes=${#value};
                        #unset value_m;
                        #value_m=`echo "get $key"$'\nquit\r\n' | nc $addr $port | head -n2 | tail -n1 | grep -e "[[:digit:]]" | tr -cd '[[:digit:]]'`

#echo "key - $key :: param - $param"
echo "$key $param" >> /etc/zabbix/scripts/ct_param_value.txt
#echo "$value_m"
 
                fi

                done
done
