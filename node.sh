#! /bin/bash

VERSION=5.9.1
FILE_NAME=node-v$VERSION-linux-x64.tar.xz
SOURCE_DIR=node-v$VERSION-linux-x64
TARGET_DIR=node
DL_ADDRESS=https://nodejs.org/dist/v$VERSION/$FILE_NAME
SOFT_DIR=/soft
if [ ! -e $SOFT_DIR ];then
echo $SOFT_DIR dir is not exists.
exit
else
wget -O $SOFT_DIR/$FILE_NAME $DL_ADDRESS
#tgz & rename
(cd $SOFT_DIR && tar -Jxf $FILE_NAME && mv $SOURCE_DIR $TARGET_DIR)
#env
sed -i '/node_/Id' /etc/profile
echo "#Node_env
NODE_HOME=$SOFT_DIR/$TARGET_DIR
PATH=\$NODE_HOME/bin:\$PATH
export PATH GROOVY_HOME
" >> /etc/profile
source /etc/profile
fi