#!/bin/bash

LOG=/var/log/oculus/import.log

PATH=/usr/local/rvm/gems/ruby-2.1.2/bin:/usr/local/rvm/gems/ruby-2.1.2@global/bin:/usr/local/rvm/rubies/ruby-2.1.2/bin:/usr/local/rvm/bin:/usr/bin:/sbin:/bin:/usr/sbin
GEM_HOME=/usr/local/rvm/gems/ruby-2.1.2
IRBRC=/usr/local/rvm/rubies/ruby-2.1.2/.irbrc
MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-2.1.2
GEM_PATH=/usr/local/rvm/gems/ruby-2.1.2:/usr/local/rvm/gems/ruby-2.1.2@global
RUBY_VERSION=ruby-2.1.2

export PATH GEM_HOME IRBRC MY_RUBY_HOME GEM_PATH RUBY_VERSION

date >> ${LOG}
/opt/oculus/scripts/import.rb >> ${LOG} 2>> ${LOG}
