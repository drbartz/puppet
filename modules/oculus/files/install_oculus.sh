#!/bin/bash

TMP_DIR=/tmp/oculus
OUTPUT_FILE=${TMP_DIR}/.install.done
PACK_FILE="/vagrant/oculus_pack.1.0.0.tgz"
SKYLINE_GIT_SOURCE="https://github.com/drbartz/skyline -b devel"
set HTTP_PROXY=http://10.10.10.2:3128
export http_proxy=http://10.10.10.2:3128

RUBY_PUPPET_VER=1.8.7
RUBY_OCULUS_VER=1.9.2
ELASTICSEARCH_VER=0.90.3

# clean and prepare temp dir
[ -d ${TMP_DIR} ] && rm -rf ${TMP_DIR}
install -d  ${TMP_DIR}
cd ${TMP_DIR}
date >  ${OUTPUT_FILE}

# install ruby RVM
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh

# try to install from tgz with slow packages ;-)
if [ -f ${PACK_FILE} ]
then
    [ -d '/usr/local/rvm/gems' ] || install -d /usr/local/rvm/gems
	cd /usr/local/rvm/gems
	tar -zxf ${PACK_FILE}
fi

# install ruby version ${RUBY_OCULUS_VER} (oculus) and 1.8.7 (puppet)
rvm install ${RUBY_OCULUS_VER}
rvm install ${RUBY_PUPPET_VER}

# prepare puppet env
rvm use ${RUBY_PUPPET_VER}
gem install json

#download oculus gig
git clone https://github.com/etsy/oculus.git

#elasticsearch install
rmv use ${RUBY_OCULUS_VER}

ELASTICSEARCH_VER="0.90.3"
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VER}.tar.gz
tar -zxvf elasticsearch-${ELASTICSEARCH_VER}.tar.gz
cd elasticsearch-${ELASTICSEARCH_VER}
cp -a ../oculus/resources/elasticsearch-oculus-plugin .
cd elasticsearch-oculus-plugin/
rake build
cp -a OculusPlugins.jar /opt/elasticsearch-${ELASTICSEARCH_VER}/lib/.

# oculus install
cd ${TMP_DIR}/oculus
gem install bundler
bundle install

# move to the final destination (/opt)
cd ${TMP_DIR}
[ -d '/opt' ] || mkdir /opt
[ -d "/opt/elasticsearch-${ELASTICSEARCH_VER}" ] && rm -rf /opt/elasticsearch-${ELASTICSEARCH_VER}
mv elasticsearch-${ELASTICSEARCH_VER} /opt/.
[ -d '/opt/oculus' ] && rm -rf /opt/oculus
mv oculus /opt/.
mv ${OUTPUT_FILE} /opt/oculus/.
