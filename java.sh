#!/usr/bin/env bash

JDK_VERSION=1.8.0_73
JAVA_VERSION=8u73
FILE_NAME=jdk-${JAVA_VERSION}-linux-x64.tar.gz
DL_ADDRESS=http://bridsystems.net/downloads/java/${FILE_NAME}
SOURCE_DIR=jdk${JDK_VERSION}
TARGET_DIR=jdk
SOFT_DIR=/soft
if [ ! -e ${SOFT_DIR} ];then
echo ${SOFT_DIR} dir is not exists.
exit
else
wget -O ${SOFT_DIR}/${FILE_NAME} ${DL_ADDRESS}
#tgz & rename
(cd ${SOFT_DIR} && tar -zxvf ${FILE_NAME} && mv ${SOURCE_DIR} ${TARGET_DIR})
#env
sed -i '/java_/Id' /etc/profile
sed -i '/CLASSPATH/Id' /etc/profile
echo "#Java_env
JAVA_HOME=${SOFT_DIR}/jdk
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH JAVA_HOME CLASSPATH
" >> /etc/profile
source /etc/profile
fi