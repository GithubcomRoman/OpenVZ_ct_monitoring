#!/bin/bash
#CT CHECK v0.2 09.04.2018 :: file ct_check_v02.sh
echo "" > /etc/zabbix/scripts/ct_param_value.txt

vz=`/usr/sbin/vzlist | awk '{print $1}' | grep -e "[[:digit:]]"`

for machine in $vz; do
                                        /usr/sbin/vzubc_custom $machine | awk '{print $1,$3}' > /tmp/vz.tmp
                                        counters=`cat /tmp/vz.tmp | sed 's/M//' | sed 's/K//' | sed 's/G//'`

                for param in $counters; do

                        if [ `echo $param | grep -e "[[:digit:]]" | wc -l` -lt 1 ]
                        then unset value; unset name; name=$param
                        else value=$param
                        fi

                        if [ `echo $value | grep -e "[[:digit:]]" | wc -l` -gt 0 ]
                        then key=${name}${machine}; bytes=${#value};

#echo "key - $key :: param - $param"
echo "$key $param" >> /etc/zabbix/scripts/ct_param_value.txt

                fi

                done
done
