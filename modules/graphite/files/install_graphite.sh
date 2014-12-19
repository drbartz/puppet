#!/bin/bash

if [ ! -f /opt/graphite/.install ]
then 
	pip install -r /opt/graphite/requirements.txt
	/usr/bin/python /opt/graphite/webapp/graphite/manage.py syncdb
	install -d /var/log/graphite/webapp
	service httpd restart
	date > /opt/graphite/.install
fi
