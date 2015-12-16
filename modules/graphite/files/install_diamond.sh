#!/bin/bash

#pre-req
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | python

cd /tmp
git clone https://github.com/python-diamond/Diamond
cd Diamond/
./setup.py install
cd .. 
rm -rf Diamond
