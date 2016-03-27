#!/usr/bin/env bash

VERSION=24.4.1
FILE_NAME=android-sdk_r$VERSION-linux.tgz
DL_ADDRESS=http://dl.google.com/android/$FILE_NAME
SOURCE_DIR=android-sdk-linux
TARGET_DIR=android-sdk
SOFT_DIR=/soft
MAIN_ENV_HOME=ANDROID_SDK_HOME
if [ ! -e $SOFT_DIR ];then
echo $SOFT_DIR dir is not exists.
exit
else
wget -O $SOFT_DIR/$FILE_NAME $DL_ADDRESS
#tgz & rename
(cd $SOFT_DIR && tar zxvf $FILE_NAME && mv $SOURCE_DIR $TARGET_DIR)
#env
sed -i '/$TARGET_DIR_/Id' /etc/profile
echo "#${TARGET_DIR}_env
$MAIN_ENV_HOME=$SOFT_DIR/$TARGET_DIR
PATH=\$${MAIN_ENV_HOME}/platform-tools:$${MAIN_ENV_HOME}/tools:\$PATH
export PATH $MAIN_ENV_HOME
" >> /etc/profile
source /etc/profile
fi