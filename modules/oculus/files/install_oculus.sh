#!/bin/bash

TMP_DIR=/tmp/oculus
OUTPUT_FILE=${TMP_DIR}/.install.done
PACK_FILE="/vagrant/skyline_python_pack.1.0.1.tgz"
SKYLINE_GIT_SOURCE="https://github.com/drbartz/skyline -b devel"

# clean and prepare temp dir
[ -d ${TMP_DIR} ] && rm -rf ${TMP_DIR}
install -d  ${TMP_DIR}
cd ${TMP_DIR}
date >  ${OUTPUT_FILE}

# try to install from tgz with slow packages ;-)
if [ -f ${PACK_FILE} ]
then
	cd /usr/lib64/python2.6/site-packages
	tar -zxf ${PACK_FILE}
fi

# install ruby version 2.1.2 (oculus) and 1.8.7 (puppet)
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.1.2
rvm install 1.8.7

# prepare puppet env
rvm use 1.8.7
gem isntall json

#download oculus gig
git clone https://github.com/etsy/oculus.git

#elasticsearch install
rmv use 2.1.2

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.0.tar.gz
tar -zxvf elasticsearch-0.90.0.tar.gz
cd elasticsearch-0.90.0
cp -a ../oculus/resources/elasticsearch-oculus-plugin .
cd elasticsearch-oculus-plugin/
rake build
cp -a OculusPlugins.jar /opt/elasticsearch-0.90.0/lib/.

# oculus install
cd ../../oculus
gem install bundler
bundle install

# move to the final destination (/opt)
cd ${TMP_DIR}
[ -d '/opt' ] || mkdir /opt
[ -d '/opt/elasticsearch-0.90.0' ] && rm -rf /opt/elasticsearch-0.90.0
mv elasticsearch-0.90.0 /opt/.
[ -d '/opt/oculus' ] && rm -rf /opt/oculus
mv oculus /opt/.
mv ${OUTPUT_FILE} /opt/oculus/.

