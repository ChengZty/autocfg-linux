#!/usr/bin/env bash

VERSION=1.6
FILE_NAME=go$VERSION.linux-amd64.tar.gz
DL_ADDRESS=https://storage.googleapis.com/golang/$FILE_NAME
SOURCE_DIR=go
TARGET_DIR=go
SOFT_DIR=/soft
MAIN_ENV_HOME=GOROOT
GOPATH=$SOFT_DIR/GOPATH
if [ ! -e $SOFT_DIR ];then
echo $SOFT_DIR dir is not exists.
exit
else
wget -O $SOFT_DIR/$FILE_NAME $DL_ADDRESS
#tgz & rename
(cd $SOFT_DIR && tar -zxvf $FILE_NAME && mv $SOURCE_DIR $TARGET_DIR)
#env
sed -i '/$TARGET_DIR_/Id' /etc/profile
echo "#${TARGET_DIR}_env
$MAIN_ENV_HOME=$SOFT_DIR/$TARGET_DIR
GOPATH=$GOPATH
PATH=\$${MAIN_ENV_HOME}/bin:\$GOPATH/bin:\$PATH
export PATH $MAIN_ENV_HOME GOPATH
" >> /etc/profile
source /etc/profile
fi