#!/bin/bash

RELEASE="2.8.19"
TMP_DIR="/tmp/redis"


[ -d ${TMP_DIR} ] || rm -rf ${TMP_DIR}
install -d ${TMP_DIR}
cd ${TMP_DIR}
wget http://download.redis.io/releases/redis-${RELEASE}.tar.gz
tar xzf redis-${RELEASE}.tar.gz
cd redis-${RELEASE}
make
cd /root 
rm -rf ${TMP_DIR}
touch /root/.install_redis.sh.done
