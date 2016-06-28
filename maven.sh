#!/usr/bin/env bash

if [ x$1 != x ];then soft_dir=$1;else soft_dir=/soft;fi
echo your soft_dir:${soft_dir}

maven_version=3.3.9
file_name=apache-maven-${maven_version}-bin.tar.gz
dl_address=http://mirrors.cnnic.cn/apache/maven/maven-3/${maven_version}/binaries/${file_name}
source_dir=apache-maven-${maven_version}
target_dir=maven
if [ ! -e ${soft_dir}  ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/${file_name} ${dl_address}
#tgz & rename
(cd ${soft_dir} && tar -zxvf ${file_name} && mv ${source_dir} ${target_dir})
#env
sed -i '/maven_/Id' /etc/profile
sed -i '/M2_HOME/Id' /etc/profile
echo "#Maven_env
M2_HOME=$soft_dir/$target_dir
PATH=\$M2_HOME/bin:\$PATH
export M2_HOME
" >> /etc/profile
source /etc/profile
fi
