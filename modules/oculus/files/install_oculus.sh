#!/bin/bash

TMP_DIR=/tmp/oculus
OUTPUT_FILE=${TMP_DIR}/.install.done
PACK_FILE="/vagrant/oculus_pack.1.0.0.tgz"
SKYLINE_GIT_SOURCE="https://github.com/drbartz/skyline -b devel"
set HTTP_PROXY=http://10.10.10.2:3128
export http_proxy=http://10.10.10.2:3128

RUBY_PUPPET_VER='1.8.7-head'
RUBY_OCULUS_VER='1.9.2-p330'
ELASTICSEARCH_VER=0.90.3

# clean and prepare temp dir
[ -d ${TMP_DIR} ] && rm -rf ${TMP_DIR}
install -d  ${TMP_DIR}
date >  ${OUTPUT_FILE}

# try to install from tgz with slow packages ;-)
if [ -f ${PACK_FILE} ]
then
    echo install pack
    [ -d '/usr/local/rvm' ] || install -d /usr/local/rvm
	cd /usr/local/rvm
	tar -zxf ${PACK_FILE}
fi

if [ ! -d '/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}' ]
then 
    # install ruby RVM
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >/dev/null
    curl -L get.rvm.io | bash -s stable >/dev/null
    source /etc/profile.d/rvm.sh

    # install ruby version ${RUBY_OCULUS_VER} (oculus) and 1.8.7 (puppet)
    rvm install ${RUBY_OCULUS_VER}
    rvm install ${RUBY_PUPPET_VER}
fi

# prepare puppet env
cd ${TMP_DIR}

rvm use ${RUBY_PUPPET_VER}
PATH=/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}/bin:/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}@global/bin:/usr/local/rvm/rubies/ruby-${RUBY_PUPPET_VER}/bin:/usr/local/rvm/bin:/usr/bin:/sbin:/bin:/usr/sbin
GEM_HOME=/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}
IRBRC=/usr/local/rvm/rubies/ruby-${RUBY_PUPPET_VER}/.irbrc
MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-${RUBY_PUPPET_VER}
GEM_PATH=/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}:/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}@global
RUBY_VERSION=ruby-${RUBY_PUPPET_VER}

[ -d "/usr/local/rvm/gems/ruby-${RUBY_PUPPET_VER}/gems/json-1.8.2" ] || gem install json > /dev/null

#download oculus gig
git clone https://github.com/etsy/oculus.git >/dev/null 2> /dev/null

#elasticsearch install
rvm use ${RUBY_OCULUS_VER}
PATH=/usr/local/rvm/gems/ruby-${RUBY_OCULUS_VER}/bin:/usr/local/rvm/gems/ruby-${RUBY_OCULUS_VER}@global/bin:/usr/local/rvm/rubies/ruby-${RUBY_OCULUS_VER}/bin:/usr/local/rvm/bin:/usr/bin:/sbin:/bin:/usr/sbin
GEM_HOME=/usr/local/rvm/gems/ruby-${RUBY_OCULUS_VER}
IRBRC=/usr/local/rvm/rubies/ruby-${RUBY_OCULUS_VER}/.irbrc
MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-${RUBY_OCULUS_VER}
GEM_PATH=/usr/local/rvm/gems/ruby-${RUBY_OCULUS_VER}:/usr/local/rvm/gems/ruby-${RUBY_OCULUS_VER}@global
RUBY_VERSION=ruby-${RUBY_OCULUS_VER}


ELASTICSEARCH_VER="0.90.3"
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VER}.tar.gz >/dev/null
tar -zxvf elasticsearch-${ELASTICSEARCH_VER}.tar.gz >/dev/null
cd elasticsearch-${ELASTICSEARCH_VER}
cp -a ../oculus/resources/elasticsearch-oculus-plugin .
cd elasticsearch-oculus-plugin/
rake build >/dev/null
cp -a OculusPlugins.jar /opt/elasticsearch-${ELASTICSEARCH_VER}/lib/.

# oculus install
cd ${TMP_DIR}/oculus
gem install bundler >/dev/null
bundle install >/dev/null

# move to the final destination (/opt)
cd ${TMP_DIR}
[ -d '/opt' ] || mkdir /opt
[ -d "/opt/elasticsearch-${ELASTICSEARCH_VER}" ] && rm -rf /opt/elasticsearch-${ELASTICSEARCH_VER}
mv elasticsearch-${ELASTICSEARCH_VER} /opt/.
[ -d '/opt/oculus' ] && rm -rf /opt/oculus
mv oculus /opt/.
mv ${OUTPUT_FILE} /opt/oculus/.
