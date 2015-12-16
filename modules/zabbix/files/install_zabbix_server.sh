#!/bin/bash

Root_Pass="ChangeMe"
Zabbix_Pass="ChangeMe"
mysql -u root -pChangeMe <<__END__
create database zabbix character set utf8;
grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by '${Zabbix_Pass}';
flush privileges;
__END__

mysql -u zabbix -p${Zabbix_Pass} zabbix < /usr/share/doc/zabbix-server-mysql-2.4.7/create/schema.sql

mysql -u zabbix -p${Zabbix_Pass} zabbix < /usr/share/doc/zabbix-server-mysql-2.4.7/create/images.sql

mysql -u zabbix -p${Zabbix_Pass} zabbix < /usr/share/doc/zabbix-server-mysql-2.4.7/create/data.sql

cd /etc/zabbix
git clone https://github.com/drbartz/zabbix_api.git
python /etc/zabbix/zabbix_api/zabbix_api.py

date > /etc/zabbix/.install_zabbix_server.done
