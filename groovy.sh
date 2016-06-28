#!/usr/bin/env bash

if [ x$1 != x ];then soft_dir=$1;else soft_dir=/soft;fi
echo your soft_dir:${soft_dir}

version=2.4.7
file_name=apache-groovy-binary-${version}.zip
source_dir=groovy-${version}
target_dir=groovy
dl_address=https://dl.bintray.com/groovy/maven/${file_name}
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/${file_name} ${dl_address}
#tgz & rename
(cd ${soft_dir} && unzip ${file_name} && mv ${source_dir} ${target_dir})
#env
sed -i '/groovy_/Id' /etc/profile
echo "#Groovy_env
GROOVY_HOME=$soft_dir/$target_dir
PATH=\$GROOVY_HOME/bin:\$PATH
export GROOVY_HOME
" >> /etc/profile
fi
source /etc/profile
