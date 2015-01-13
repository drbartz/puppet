#!/bin/bash

TMP_DIR=/tmp/skyline
OUTPUT_FILE=${TMP_DIR}/.install.done
[ -d ${TMP_DIR} ] && rm -rf ${TMP_DIR}
install -d  ${TMP_DIR}
cd ${TMP_DIR}
date >  ${OUTPUT_FILE}

# install Python pre-reqs 
cat > requirements.txt << __END__
redis==2.7.2
hiredis==0.1.1
python-daemon==1.6
flask==0.9
simplejson==2.0.9
unittest2
mock
#python-simple-hipchat
msgpack-python
#numpy
pandas
#scipy
patsy
statsmodels
__END__

pip install --upgrade numpy >> ${OUTPUT_FILE} 2>>  ${OUTPUT_FILE}
pip install -r requirements.txt >> ${OUTPUT_FILE} 2>>  ${OUTPUT_FILE}
git clone https://github.com/etsy/skyline  >> ${OUTPUT_FILE} 2>>  ${OUTPUT_FILE}
[ -d '/opt' ] || mkdir /opt
[ -d '/opt/skyline' ] && rm -rf /opt/skyline
mv skyline /opt
mv ${OUTPUT_FILE} /opt/skyline/.
