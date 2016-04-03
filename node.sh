#!/usr/bin/env bash

VERSION=5.10.0
FILE_NAME=node-v${VERSION}-linux-x64.tar.xz
SOURCE_DIR=node-v${VERSION}-linux-x64
target_dir=node
DL_ADDRESS=https://nodejs.org/dist/v$VERSION/$FILE_NAME
soft_dir=/soft
if [ ! -e $soft_dir ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/$FILE_NAME $DL_ADDRESS
#tgz & rename
rm -rf ${soft_dir}/${target_dir}
(cd $soft_dir && tar -Jxf $FILE_NAME && mv $SOURCE_DIR $target_dir)
#env
sed -i '/node_/Id' /etc/profile
echo "#Node_env
NODE_HOME=$soft_dir/$target_dir
PATH=\$NODE_HOME/bin:\$PATH
export PATH NODE_HOME
" >> /etc/profile
source /etc/profile
fi