#!/bin/bash

Root_Pass="ChangeMe"
Zabbix_Pass="ChangeMe"
mysql -u root -pChangeMe <<__END__
create database zabbix character set utf8;
grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by '${Zabbix_Pass}';
flush privileges;
__END__

mysql -u zabbix -p${Zabbix_Pass} zabbix < /usr/share/doc/zabbix-server-mysql-2.4.3/create/schema.sql

mysql -u zabbix -p${Zabbix_Pass} zabbix < /usr/share/doc/zabbix-server-mysql-2.4.3/create/images.sql

mysql -u zabbix -p${Zabbix_Pass} zabbix < /usr/share/doc/zabbix-server-mysql-2.4.3/create/data.sql

date > /etc/zabbix/.install_zabbix_server.done
