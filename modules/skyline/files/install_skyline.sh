#!/bin/bash

TMP_DIR=/tmp/skyline
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

# install Python pre-reqs 
cat > requirements.txt << __END__
redis==2.7.2
cython
hiredis==0.1.1
python-daemon==1.6
flask==0.9
simplejson==2.0.9
#unittest2
unittest2==0.5.1
#mock
mock==1.0.1
python-simple-hipchat
#msgpack-python
msgpack-python==0.4.2
#numpy
numpy==1.9.0
#pandas
pandas==0.14.1
#scipy
scipy==0.10.1
#patsy
patsy==0.3.0
#statsmodels
statsmodels==0.4.3
__END__

cat requirements.txt | grep -v ^# | while read pack; do echo $pack `date`; pip install $pack;done >> ${OUTPUT_FILE} 2>>  ${OUTPUT_FILE}
git clone ${SKYLINE_GIT_SOURCE}  >> ${OUTPUT_FILE} 2>>  ${OUTPUT_FILE}
[ -d '/opt' ] || mkdir /opt
[ -d '/opt/skyline' ] && rm -rf /opt/skyline
mv skyline /opt
mv ${OUTPUT_FILE} /opt/skyline/.
