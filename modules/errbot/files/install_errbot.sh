#!/bin/bash

yum update -y
yum install -y python34 python34-devel  python34-setuptools python-pip
yum install -y gcc libffi-devel python-devel openssl-devel
easy_install-3.4 errbot errbot[telegram]  errbot[slack]

date > /etc/errbot/.install_errbot.done
