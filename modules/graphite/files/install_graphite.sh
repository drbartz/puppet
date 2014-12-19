#!/bin/bash

if [ ! -f /opt/graphite/.install ]
then 
	pip install -r /opt/graphite/requirements.txt
	/usr/bin/python /opt/graphite/webapp/graphite/manage.py syncdb
	service httpd restart
	date > /opt/graphite/.install
fi
