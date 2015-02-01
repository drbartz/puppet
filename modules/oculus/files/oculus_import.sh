#!/bin/bash

LOG=/var/log/oculus/import.log

PATH=/usr/local/rvm/gems/ruby-1.9.2-p330/bin:/usr/local/rvm/gems/ruby-1.9.2-p330@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p330/bin:/usr/local/rvm/bin:/usr/bin:/sbin:/bin:/usr/sbin
GEM_HOME=/usr/local/rvm/gems/ruby-1.9.2-p330
IRBRC=/usr/local/rvm/rubies/ruby-1.9.2-p330/.irbrc
MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-1.9.2-p330
GEM_PATH=/usr/local/rvm/gems/ruby-1.9.2-p330:/usr/local/rvm/gems/ruby-1.9.2-p330@global
RUBY_VERSION=ruby-1.9.2-p330

export PATH GEM_HOME IRBRC MY_RUBY_HOME GEM_PATH RUBY_VERSION

date >> ${LOG}
cd /opt/oculus/scripts/
./import.rb >> ${LOG} 2>> ${LOG}
