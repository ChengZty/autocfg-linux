#!/usr/bin/env bash

jdk_version=1.8.0_91
java_version=8u91
file_name=jdk-${java_version}-linux-x64.tar.gz
dl_address=http://bridsystems.net/downloads/java/${file_name}
source_dir=jdk${jdk_version}
target_dir=jdk
soft_dir=/soft
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/${file_name} ${dl_address}
#tgz & rename
(cd ${soft_dir} && tar -zxvf ${file_name} && mv ${source_dir} ${target_dir})
#env
sed -i '/java_/Id' /etc/profile
sed -i '/CLASSPATH/Id' /etc/profile
echo "#Java_env
JAVA_HOME=${soft_dir}/jdk
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH JAVA_HOME CLASSPATH
" >> /etc/profile
source /etc/profile
fi