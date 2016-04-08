#!/usr/bin/env bash

if [ x$1 != x ];then soft_dir=$1;else soft_dir=/soft;fi
echo your soft_dir:${soft_dir}
version=5.10.1
file_name=node-v${version}-linux-x64.tar.xz
source_dir=node-v${version}-linux-x64
target_dir=node
dl_address=https://nodejs.org/dist/v${version}/${file_name}
soft_dir=/soft
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/${file_name} ${dl_address}
#tgz & rename
rm -rf ${soft_dir}/${target_dir}
(cd ${soft_dir} && tar -Jxf ${file_name} && mv ${source_dir} ${target_dir})
#env
sed -i '/node_/Id' /etc/profile
echo "#Node_env
NODE_HOME=$soft_dir/$target_dir
PATH=\$NODE_HOME/bin:\$PATH
export PATH NODE_HOME
" >> /etc/profile
source /etc/profile
fi