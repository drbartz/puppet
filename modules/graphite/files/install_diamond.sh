#!/bin/bash

cd /tmp
git clone https://github.com/python-diamond/Diamond
cd Diamond/
./setup.py install
cd .. 
rm -rf Diamond
