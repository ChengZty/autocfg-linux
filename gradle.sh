#!/usr/bin/env bash

VERSION=2.13
FILE_NAME=gradle-${VERSION}-bin.zip
DL_ADDRESS=https://services.gradle.org/distributions/${FILE_NAME}
SOURCE_DIR=gradle-${VERSION}
TARGET_DIR=gradle
SOFT_DIR=/soft
MAIN_ENV_HOME=GRADLE_HOME
if [ ! -e ${SOFT_DIR} ];then
echo ${SOFT_DIR} dir is not exists.
exit
else
wget -O ${SOFT_DIR}/${FILE_NAME} ${DL_ADDRESS}
#tgz & rename
(cd ${SOFT_DIR} && unzip ${FILE_NAME} && mv ${SOURCE_DIR} ${TARGET_DIR})
#env
sed -i '/${TARGET_DIR}_/Id' /etc/profile
echo "#${TARGET_DIR}_env
$MAIN_ENV_HOME=$SOFT_DIR/$TARGET_DIR
PATH=\$${MAIN_ENV_HOME}/bin:\$PATH
export PATH $MAIN_ENV_HOME
" >> /etc/profile
source /etc/profile
fi