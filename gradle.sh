#!/usr/bin/env bash

if [ x$1 != x ];then soft_dir=$1;else soft_dir=/soft;fi
echo your soft_dir:${soft_dir}

version=2.14
file_name=gradle-${version}-bin.zip
dl_address=https://services.gradle.org/distributions/${file_name}
source_dir=gradle-${version}
target_dir=gradle
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/${file_name} ${dl_address}
#tgz & rename
(cd ${soft_dir} && unzip ${file_name} && mv ${source_dir} ${target_dir})
#env
sed -i '/Gradle_/Id' /etc/profile
echo "#Gradle_env
GRADLE_HOME=$soft_dir/$target_dir
PATH=\$GRADLE_HOME/bin:\$PATH
export PATH GRADLE_HOME
" >> /etc/profile
source /etc/profile
fi