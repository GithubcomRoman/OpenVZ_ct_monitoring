# OpenVZ_ct_monitoring
Мониторинг контейнеров OpenVZ  

######Установка:  ######
git clone https://github.com/GithubcomRoman/OpenVZ_ct_monitoring.git  
cd OpenVZ_ct_monitoring/  
chmod +x install.sh  
./install.sh  

Успешная установка выглядит вот так:  

|--Check Zabbix Agent activ...  
+OK - Zabbix agent run  
|--Check openZV config for Zabbix Agent...  
+OK - /etc/zabbix/zabbix_agentd.d/open_vz.conf  
|--Check scripts for Zabbix Agent...  
+OK - /etc/zabbix/scripts/ct_param_name.sh  
+OK - /etc/zabbix/scripts/ct_param_value.sh  
+OK - /etc/zabbix/scripts/ct_failcnt_name.sh  
+OK - /etc/zabbix/scripts/ct_failcnt_value.sh  
+OK - /root/ct_check_v02.sh  
+OK - /root/failcnt_count.sh  
+OK - /usr/sbin/vzubc_custom  

Добавить в cron строки:  

* * * * * /root/./ct_check_v02.sh  
* * * * * /root/./failcnt_count.sh  

Добавть шаблон в заббикс и применить его к хост-машине с контейнерами - https://github.com/GithubcomRoman/OpenVZ_ct_monitoring/blob/master/template/OpenVZ_ct_param.xml
Все Items будут автоматически созданы в Applications под названием Open_VZ. Если контейнеры имеют названия в числовом виде, то Items будут иметь следующий вид:  

othersockbuf779  
othersockbuf8888  

######Расшифровка параметров (https://wiki.openvz.org/UBC_parameters_table)  ######
numproc - Максимальное количество процессов и тредов (потоков).  
numothersock - Максимальное количество TCP-сокетов.  
vmguarpages - Гарантированный объем оперативной памяти, которая может быть запрошена стандартными механизмами резервирования памяти в Linux.  
kmemsize - Память ядра — объем оперативной памяти, выделяемый для внутренних структур данных ядра, связанных с процессами виртуального сервера. Каждый процесс запрашивает как минимум 24 Кб таких данных. Средний процесс использует 30—60 Кб ядерной памяти. Большие процессы, такие как Apache и MySQL, могут использовать гораздо больше.
tcpsndbuf - Суммарный размер буферов, которых может быть использован для отправки данных через TCP-соединения.
tcprcvbuf - Суммарный размер буферов, которых может быть использован для приема данных через TCP-соединения.
othersockbuf - Суммарный размер буферов, которые могут быть использованы как для приема, так и для отправки данных через локальные сокеты, а также буферы, используемые для отправки данных по протоколу UDP.
dgrampages - Суммарный размер буферов, которые могут быть использованы для приема данных через UDP-соединения.
privvmpages - Объем оперативной памяти, которая может быть запрошена процессами виртуального * сервера системным вызовом malloc и другими стандартными механизмами резервирования памяти в Linux.
oomguarpages - Гарантированный объем оперативной памяти, превышение которого вызовет сигнал outof-memory.
lockedpages - Объем памяти, которая может быть заблокирована с помощью системного вызова mlock. Этот объем включен в kmemsize.
shmpages - Общий объем разделяемой оперативной памяти (IPC). Этот параметр включен в privvmpages.
numfile - Максимальное количество открытых файлов.
numflock - Максимальное количество возможных блокировок файлов.
numpty - Максимальное количество псевдо-терминалов.
numsiginfo - Максимальное количество siginfo-структур. Размер структуры включен в kmemsize.
dcachesize - Объем памяти, необходимый для блокировки dentry- и inode-структур. Объем этой памяти включен в kmemsize.
numiptent - Максимальное количество записей в firewall (netfilter).

все параметры вида «*pages» измеряется в 4 Кб страницах;
все параметры вида «num*» измеряется в штуках;
все остальные параметры («*size», «*buf») измеряется в байтах.
