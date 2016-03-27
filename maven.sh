#!/usr/bin/env bash

MAVEN_VERSION=3.3.9
FILE_NAME=apache-maven-$MAVEN_VERSION-bin.tar.gz
DL_ADDRESS=http://mirrors.cnnic.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/$FILE_NAME
SOURCE_DIR=apache-maven-$MAVEN_VERSION
TARGET_DIR=maven
SOFT_DIR=/soft
MAIN_ENV_HOME=MAVEN_HOME
if [ ! -e $SOFT_DIR ];then
echo $SOFT_DIR dir is not exists.
exit
else
wget -O $SOFT_DIR/$FILE_NAME $DL_ADDRESS
#tgz & rename
(cd $SOFT_DIR && tar -zxvf $FILE_NAME && mv $SOURCE_DIR $TARGET_DIR)
#env
sed -i '/maven_/Id' /etc/profile
echo "#Maven_env
$MAIN_ENV_HOME=$SOFT_DIR/$TARGET_DIR
PATH=\$${MAIN_ENV_HOME}/bin:\$PATH
export PATH $MAIN_ENV_HOME
" >> /etc/profile
source /etc/profile
fi
